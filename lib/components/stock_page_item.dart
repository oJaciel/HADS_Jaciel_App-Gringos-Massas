import 'package:app_gringos_massas/components/product_image.dart';
import 'package:app_gringos_massas/models/product.dart';
import 'package:flutter/material.dart';

class StockPageItem extends StatelessWidget {
  const StockPageItem(this.product, {super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    if (product.isActive) {
      return Card(
        child: ListTile(
          leading: ProductImage(product: product, height: 70, width: 60),
          title: Text(product.name),
          subtitle: Text('Em estoque: ${product.stockQuantity}'),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
