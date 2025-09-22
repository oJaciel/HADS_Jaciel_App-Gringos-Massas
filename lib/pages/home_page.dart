import 'package:app_gringos_massas/components/home_page_button.dart';
import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:app_gringos_massas/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Provider.of<ProductProvider>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gringo\'s Massas')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Image.asset(
              'assets/logo.png',
              width: MediaQuery.sizeOf(context).width * 0.5,
            ),
            SizedBox(height: 16),
            Expanded(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                

                children: [
                  HomePageButton(
                    title: 'Produtos',
                    icon: Icons.sell_rounded,
                    route: AppRoutes.PRODUCTS,
                  ),
                  HomePageButton(
                    title: 'Estoque',
                    icon: Icons.inventory_2_rounded,
                    route: AppRoutes.STOCK,
                  ),
                  HomePageButton(
                    title: 'Vendas',
                    icon: Icons.shopping_cart_rounded,
                    route: AppRoutes.SALES,
                  ),
                  HomePageButton(
                    title: 'Relatórios',
                    icon: Icons.analytics_rounded,
                    route: AppRoutes.REPORTS,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
