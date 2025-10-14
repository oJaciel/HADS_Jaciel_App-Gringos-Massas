import 'dart:convert';

import 'package:app_gringos_massas/models/sale.dart';
import 'package:app_gringos_massas/models/sale_item.dart';
import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:app_gringos_massas/providers/sale_item_provider.dart';
import 'package:app_gringos_massas/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

enum PaymentMethod { Cash, Pix, CreditCard }

class SaleProvider with ChangeNotifier {
  final List<Sale> _sales = [];

  List<Sale> get sales => [..._sales];

  int get salesCount => _sales.length;

  Future<void> loadSales() async {
    _sales.clear();

    final response = await http.get(
      Uri.parse('${Constants.SALE_BASE_URL}.json'),
    );

    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((saleId, saleData) {
      _sales.add(
        Sale(
          id: saleId,
          total: saleData['total'],
          date: DateTime.parse(saleData['date']),
          clientName: saleData['clientName'] ?? '',
          paymentMethod: saleData['paymentMethod'] != null
              ? PaymentMethod.values.firstWhere(
                  (e) => e.name == saleData['paymentMethod'],
                )
              : null,
          products: (saleData['products'] as List<dynamic>).map((item) {
            return SaleItem(
              productId: item['productId'],
              name: item['name'],
              quantity: item['quantity'],
              unitPrice: item['unitPrice'],
            );
          }).toList(),
        ),
      );
    });

    //Ordena a lista por ordem de data
    _sales.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  Future<void> addSale(
    BuildContext context,
    String? clientName,
    PaymentMethod? paymentMethod,
    DateTime date,
  ) async {
    final saleItemProvider = Provider.of<SaleItemProvider>(
      context,
      listen: false,
    );

    for (var saleItem in saleItemProvider.items.values) {
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );
      final product = productProvider.getProductById(saleItem.productId);

      final updatedStockQuantity = product.stockQuantity - saleItem.quantity;

      bool success = await productProvider.updateProductStock(
        product,
        updatedStockQuantity,
        context,
      );

      await productProvider.loadProducts(); //Faz um load dos produtos para atualizar os estoques na tela

      if (!success) {
        // Interrompe todo o processo se algum produto falhar
        return;
      }
    }

    final response = await http.post(
      Uri.parse('${Constants.SALE_BASE_URL}.json'),
      body: jsonEncode({
        "products": saleItemProvider.items.values
            .map(
              (saleItem) => {
                "productId": saleItem.productId,
                "name": saleItem.name,
                "quantity": saleItem.quantity,
                "unitPrice": saleItem.unitPrice,
              },
            )
            .toList(),
        "total": saleItemProvider.totalAmount,
        if (clientName!.isNotEmpty && clientName != '')
          "clientName": clientName,
        "paymentMethod": paymentMethod?.name,
        "date": date.toIso8601String(),
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception('Erro ao gravar transação: ${response.body}');
    }

    final saleId = jsonDecode(response.body)['name'];

    _sales.add(
      Sale(
        id: saleId,
        products: saleItemProvider.items.values.toList(),
        total: saleItemProvider.totalAmount,
        clientName: clientName,
        paymentMethod: paymentMethod,
        date: date,
      ),
    );

    //Limpa a lista dos itens de venda
    saleItemProvider.clear();
    Navigator.of(context).pop();

    loadSales();

    //Ordena a lista por ordem de data
    _sales.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  
}
