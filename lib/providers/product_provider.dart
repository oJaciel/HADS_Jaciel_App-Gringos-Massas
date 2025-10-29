import 'dart:convert';

import 'package:app_gringos_massas/components/dialogs/error_dialog.dart';
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

  List<Product> get activeProducts => [..._products.where((p) => p.isActive)];

  int get activeProductsCount {
    return activeProducts.length;
  }

  Product getProductById(String productId) {
    final product = products.firstWhere((p) => productId == p.id);
    return product;
  }

  //Carregando os produtos do Firebase
  Future<void> loadProducts() async {
    _products.clear();
    final response = await http.get(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json'),
    );

    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      _products.add(
        Product(
          id: productId,
          name: productData['name'],
          imageUrl: productData['imageUrl'],
          price: (productData['price'] as num).toDouble(),
          stockQuantity: productData['stockQuantity'] ?? 0,
          isActive: productData['isActive'] ?? true,
          hasMovement: productData['hasMovement'] ?? false,
        ),
      );
    });
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    if (product.name.trim() == '' ||
        product.name.length <= 3 ||
        product.price <= 0)
      return;

    final response = await http.post(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json'),
      body: jsonEncode({
        "name": product.name,
        "imageUrl": product.imageUrl,
        "price": product.price,
        "isActive": product.isActive,
        "stockQuantity": product.stockQuantity,
        "hasMovement": product.hasMovement,
      }),
    );

    final productId = jsonDecode(response.body)['name'];

    _products.add(
      Product(
        id: productId,
        name: product.name,
        imageUrl: product.imageUrl,
        price: product.price,
        stockQuantity: product.stockQuantity,
        hasMovement: product.hasMovement,
        isActive: product.isActive,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    if (product.name.trim() == '' ||
        product.name.length <= 3 ||
        product.price <= 0)
      return;

    int index = _products.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('${Constants.PRODUCT_BASE_URL}/${product.id}.json'),
        body: jsonEncode({
          "name": product.name,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "isActive": product.isActive,
          "stockQuantity": product.stockQuantity,
          "hasMovement": product.hasMovement,
        }),
      );

      _products[index] = product;
      notifyListeners();
    }
  }

  Future<bool> updateProductStock(
    Product product,
    int quantity,
    BuildContext context,
  ) async {
    int index = _products.indexWhere((p) => p.id == product.id);

    if (quantity < 0) {
      await showDialog(
        context: context,
        builder: (ctx) =>
            ErrorDialog(content: 'Ação irá causar estoque negativo!'),
      );
      return false;
    }

    if (index >= 0) {
      await http.patch(
        Uri.parse('${Constants.PRODUCT_BASE_URL}/${product.id}.json'),
        body: jsonEncode({"stockQuantity": quantity}),
      );

      await updateProductMovement(product);

      notifyListeners();
    }
    return true;
  }

  void removeProduct(Product product) async {
    int index = _products.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _products[index];
      //Exclui produto da lista local
      _products.remove(product);
      notifyListeners();

      //Exclui produto do banco
      final response = await http.delete(
        Uri.parse('${Constants.PRODUCT_BASE_URL}/${product.id}.json'),
      );

      //Caso der erro na exclusão do banco, insere de volta o produto
      if (response.statusCode >= 400) {
        _products.insert(index, product);
        notifyListeners();
      }
    }
  }

  Future<void> updateProductMovement(Product product) async {
    int index = _products.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse('${Constants.PRODUCT_BASE_URL}/${product.id}.json'),
        body: jsonEncode({
          //Se produto já teve movimentação antes, não precisa atualizar
          if (product.hasMovement == false) "hasMovement": true,
        }),
      );

      notifyListeners();
    }
  }
}
