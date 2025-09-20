import 'dart:math';

import 'package:app_gringos_massas/models/product.dart';
import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    Product product = Product(
      name: 'Teste',
      imageUrl: '',
      price: 10,
      id: Random().nextDouble().toString(),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Produtos')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Provider.of<ProductProvider>(context, listen: false).addProduct(product);
          },
          child: Text('Teste'),
        ),
      ),
    );
  }
}
