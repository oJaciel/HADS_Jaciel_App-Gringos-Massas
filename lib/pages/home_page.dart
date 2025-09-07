import 'package:app_gringos_massas/components/home_page_button.dart';
import 'package:app_gringos_massas/utils/app_routes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gringo\'s Massas')),
      body: Column(
        children: [
          HomePageButton(
            title: 'Produtos',
            icon: Icon(Icons.sell_rounded),
            route: AppRoutes.PRODUCTS,
          ),
          HomePageButton(
            title: 'Estoque',
            icon: Icon(Icons.inventory_2_rounded),
            route: AppRoutes.STOCK,
          ),
          HomePageButton(
            title: 'Vendas',
            icon: Icon(Icons.shopping_cart_rounded),
            route: AppRoutes.SALES,
          ),
        ],
      ),
    );
  }
}
