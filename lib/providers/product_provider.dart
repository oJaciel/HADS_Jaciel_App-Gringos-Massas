import 'dart:convert';

import 'package:app_gringos_massas/models/product.dart';
import 'package:app_gringos_massas/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => [..._products];

  int get productsCount {
    return _products.length;
  }

  //Carregando os produtos do Firebase
  Future<void> loadProducts() async {
    _products.clear();
    final response = await http.get(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json'),
    );
    if (response.body == null) return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      _products.add(
        Product(
          id: productId,
          name: productData['name'],
          imageUrl: productData['imageUrl'],
          price: productData['value'],
        ),
      );
    });
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json'),
      body: jsonEncode({
        "name": product.name,
        "imageUrl": product.imageUrl,
        "price": product.price,
        "isActive": product.isActive,
      }),
    );

    final productId = jsonDecode(response.body)['name'];

    _products.add(
      Product(
        id: productId,
        name: product.name,
        imageUrl: product.imageUrl,
        price: product.price,
      ),
    );
    notifyListeners();
  }
}
