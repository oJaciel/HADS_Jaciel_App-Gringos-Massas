import 'dart:convert';

import 'package:app_gringos_massas/components/error_dialog.dart';
import 'package:app_gringos_massas/models/product.dart';
import 'package:app_gringos_massas/models/stock_transaction.dart';
import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:app_gringos_massas/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum TransactionType { entry, out }

class StockProvider with ChangeNotifier {
  final List<StockTransaction> _transactions = [];

  List<StockTransaction> get transactions => [..._transactions];

  int get transactionsCount => _transactions.length;

  Future<void> loadTransactions() async {
    _transactions.clear();
    final response = await http.get(
      Uri.parse('${Constants.STOCK_BASE_URL}.json'),
    );
    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((transactionId, transactionData) {
      _transactions.add(
        StockTransaction(
          id: transactionId,
          product: Product(
            id: transactionData['product']['id'] ?? '',
            name: transactionData['product']['name'] ?? '',
            imageUrl: transactionData['product']['imageUrl'] ?? '',
            price: (transactionData['product']['price'] as num).toDouble(),
            stockQuantity: transactionData['product']['stockQuantity'] ?? 0,
            isActive: transactionData['product']['isActive'] ?? true,
            hasMovement: transactionData['product']['hasMovement'] ?? false,
          ),
          quantity: transactionData['quantity'],
          type: transactionData['transactionType'] == 'entry'
              ? TransactionType.entry
              : TransactionType.out,
          date: DateTime.parse(transactionData['date']),
        ),
      );
    });

    // Ordena a lista por data decrescente
    _transactions.sort((a, b) => b.date.compareTo(a.date));

    notifyListeners();
  }

  /// Adiciona uma transação de estoque (entrada ou saída)
  Future<void> addTransaction(
    BuildContext context,
    ProductProvider productProvider,
    Product product,
    int quantity,
    TransactionType type,
  ) async {
    // Calcula a nova quantidade de estoque do produto
    int updatedStockQuantity = product.stockQuantity;
    if (type == TransactionType.entry) {
      updatedStockQuantity += quantity;
    } else if (type == TransactionType.out) {
      updatedStockQuantity -= quantity;
    }

    //Se a nova quantidade em estoque causar negativo, cancela
    if (updatedStockQuantity < 0) {
      showDialog(
        context: context,
        builder: (ctx) =>
            ErrorDialog(content: 'Saída não pode causar estoque negativo!'),
      );
      return;
    }

    //Adiciona a nova transação no banco
    final response = await http.post(
      Uri.parse('${Constants.STOCK_BASE_URL}.json'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "product": ({
          "name": product.name,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "isActive": product.isActive,
          "stockQuantity": product.stockQuantity,
          "hasMovement": product.hasMovement,
        }),
        "quantity": quantity,
        "transactionType": type.name,
        "date": DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception('Erro ao gravar transação: ${response.body}');
    }

    final transactionId = jsonDecode(response.body)['name'];

    //Cria a transação localmente
    _transactions.add(
      StockTransaction(
        id: transactionId,
        product: product,
        quantity: quantity,
        type: type,
        date: DateTime.now(),
      ),
    );

    // Ordena a lista por data decrescente
    _transactions.sort((a, b) => b.date.compareTo(a.date));

    notifyListeners();

    // Chama o método de atualizar o estoque do produto
    await productProvider.updateProductStock(product, updatedStockQuantity);

    await productProvider.loadProducts();

    Navigator.of(context).pop();
  }
}
