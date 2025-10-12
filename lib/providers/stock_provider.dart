import 'dart:convert';

import 'package:app_gringos_massas/components/dialogs/error_dialog.dart';
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
    int updatedStockQuantity = product.stockQuantity;
    if (type == TransactionType.entry) {
      updatedStockQuantity += quantity;
    } else {
      updatedStockQuantity -= quantity;
    }

    if (updatedStockQuantity < 0) {
      showDialog(
        context: context,
        builder: (ctx) =>
            ErrorDialog(content: 'Saída não pode causar estoque negativo!'),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('${Constants.STOCK_BASE_URL}.json'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "product": {
          "id": product.id,
          "name": product.name,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "isActive": product.isActive,
          "stockQuantity": product.stockQuantity,
          "hasMovement": product.hasMovement,
        },
        "quantity": quantity,
        "transactionType": type.name,
        "date": DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception('Erro ao gravar transação: ${response.body}');
    }

    final transactionId = jsonDecode(response.body)['name'];

    _transactions.add(
      StockTransaction(
        id: transactionId,
        product: product,
        quantity: quantity,
        type: type,
        date: DateTime.now(),
      ),
    );

    _transactions.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();

    await productProvider.updateProductStock(
      product,
      updatedStockQuantity,
      context,
    );
    await productProvider.loadProducts();

    Navigator.of(context).pop();
  }

  Future<void> removeTransaction(
    BuildContext context,
    ProductProvider productProvider,
    StockTransaction transaction,
  ) async {
    final transactionIndex = _transactions.indexWhere(
      (t) => t.id == transaction.id,
    );
    if (transactionIndex < 0) return;

    final productIndex = productProvider.products.indexWhere(
      (p) => p.id == transaction.product.id,
    );
    if (productIndex < 0) return;

    final transactionProduct = productProvider.products[productIndex];

    // Corrigir cálculo de estoque
    int updatedStockQuantity = transactionProduct.stockQuantity;
    if (transaction.type == TransactionType.entry) {
      updatedStockQuantity -= transaction.quantity;
    } else {
      updatedStockQuantity += transaction.quantity;
    }

    if (updatedStockQuantity < 0) {
      showDialog(
        context: context,
        builder: (ctx) =>
            ErrorDialog(content: 'Saída não pode causar estoque negativo!'),
      );
      return;
    }

    print('Excluindo transação: ${transaction.id}');
    final response = await http.delete(
      Uri.parse('${Constants.STOCK_BASE_URL}/${transaction.id}.json'),
    );

    if (response.statusCode >= 400) {
      throw Exception('Erro ao excluir transação: ${response.body}');
    }

    // Só remove localmente se o backend excluiu com sucesso
    _transactions.removeAt(transactionIndex);
    notifyListeners();

    await productProvider.updateProductStock(
      transactionProduct,
      updatedStockQuantity,
      context,
    );

    await productProvider.loadProducts();
  }
}
