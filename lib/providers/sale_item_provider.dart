import 'package:app_gringos_massas/models/product.dart';
import 'package:app_gringos_massas/models/sale_item.dart';
import 'package:flutter/material.dart';

class SaleItemProvider with ChangeNotifier {
  Map<String, SaleItem> _items = {};

  Map<String, SaleItem> get items {
    return {..._items};
  }

  int get itemsCounts {
    return items.length;
  }

  //Método pra calcular total da venda
  double get totalAmount {
    double total = 0;
    _items.forEach((key, saleItem) {
      total += saleItem.unitPrice * saleItem.quantity;
    });
    return total;
  }

  void addItem(Product product) {
    //Primeiro valida se já tem esse produto no carrinho. Se tiver, só adiciona mais um na quantidade.
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingProduct) => SaleItem(
          productId: existingProduct.productId,
          name: existingProduct.name,
          quantity: existingProduct.quantity + 1,
          unitPrice: existingProduct.unitPrice,
        ),
      );
    } else {
      //Se não tem, adiciona o produto na lista
      _items.putIfAbsent(
        product.id,
        () => SaleItem(
          productId: product.id,
          name: product.name,
          quantity: 1,
          unitPrice: product.price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
