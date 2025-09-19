import 'package:app_gringos_massas/pages/home_page.dart';
import 'package:app_gringos_massas/pages/products/products_page.dart';
import 'package:app_gringos_massas/pages/reports/reports_page.dart';
import 'package:app_gringos_massas/pages/sales/sales_page.dart';
import 'package:app_gringos_massas/pages/stock/stock_page.dart';
import 'package:app_gringos_massas/utils/app_routes.dart';
import 'package:app_gringos_massas/utils/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Gringo\'s Massas',
      theme: appTheme,
      initialRoute: AppRoutes.HOME,
      routes: {
        AppRoutes.HOME: (ctx) => HomePage(),
        AppRoutes.PRODUCTS: (ctx) => ProductsPage(),
        AppRoutes.SALES: (ctx) => SalesPage(),
        AppRoutes.STOCK: (ctx) => StockPage(),
        AppRoutes.REPORTS: (ctx) => ReportsPage(),
      },
    );
  }
}