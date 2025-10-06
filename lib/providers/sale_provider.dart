import 'dart:convert';

import 'package:app_gringos_massas/models/sale.dart';
import 'package:app_gringos_massas/providers/sale_item_provider.dart';
import 'package:app_gringos_massas/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum PaymentMethod { Cash, Pix, CreditCard }

class SaleProvider with ChangeNotifier {
  final List<Sale> _sales = [];

  List<Sale> get sales => [..._sales];

  int get salesCount => _sales.length;

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

    final saleId = jsonDecode(response.body)['name'];

    _sales.add(
      Sale(
        id: saleId,
        products: saleItemProvider.items.values.toList(),
        total: total,
        clientName: clientName,
        paymentMethod: paymentMethod,
        date: date.toIso8601String(),
      ),
    );
  }
}
