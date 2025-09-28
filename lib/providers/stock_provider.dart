import 'dart:convert';

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

  /// Adiciona uma transação de estoque (entrada ou saída)
  Future<void> addTransaction(
    ProductProvider productProvider,
    Product product,
    int quantity,
    TransactionType type,
  ) async {
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

    notifyListeners();

    // Calcula a nova quantidade de estoque do produto
    int updatedStockQuantity = product.stockQuantity;
    if (type == TransactionType.entry) {
      updatedStockQuantity += quantity;
    } else if (type == TransactionType.out) {
      updatedStockQuantity -= quantity;
    }

    // Chama o método de atualizar o estoque do produto
    await productProvider.updateProductStock(product, updatedStockQuantity);
  }
}
