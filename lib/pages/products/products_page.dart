import 'package:app_gringos_massas/components/products/product_page_item.dart';
import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:app_gringos_massas/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORM),
            icon: Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORM),
                label: Text('Adicionar Novo Produto'),
                icon: Icon(Icons.add_rounded),
              ),
            ),
            SizedBox(height: 6),
            Flexible(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 4),
                itemCount: provider.productsCount,
                itemBuilder: (ctx, i) => ProductPageItem(provider.products[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
