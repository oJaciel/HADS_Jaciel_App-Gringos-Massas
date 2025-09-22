import 'package:app_gringos_massas/components/product_page_item.dart';
import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Produtos')),
      body: Padding(
        padding: EdgeInsetsGeometry.all(8),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3/2
          ),
          padding: EdgeInsets.all(4),
          itemCount: provider.productsCount,
          itemBuilder: (ctx, i) => ProductPageItem(provider.products[i]),
        ),
      ),
    );
  }
}
