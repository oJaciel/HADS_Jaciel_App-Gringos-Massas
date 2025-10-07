import 'dart:convert';

import 'package:app_gringos_massas/models/sale.dart';
import 'package:app_gringos_massas/models/sale_item.dart';
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
          paymentMethod: saleData['paymentMethod'] == 'Cash'
              ? PaymentMethod.Cash
              : saleData['paymentMethod'] == 'Pix'
              ? PaymentMethod.Pix
              : PaymentMethod.CreditCard,
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
    SaleItemProvider saleItemProvider,
    double total,
    String? clientName,
    PaymentMethod? paymentMethod,
    DateTime date,
  ) async {
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
        "total": total,
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
        total: total,
        clientName: clientName,
        paymentMethod: paymentMethod,
        date: date,
      ),
    );

    //Ordena a lista por ordem de data
    _sales.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }
}
