import 'package:app_gringos_massas/pages/home_page.dart';
import 'package:app_gringos_massas/pages/products/product_form_page.dart';
import 'package:app_gringos_massas/pages/products/products_page.dart';
import 'package:app_gringos_massas/pages/reports/reports_page.dart';
import 'package:app_gringos_massas/pages/sales/sale_form_page.dart';
import 'package:app_gringos_massas/pages/sales/sales_page.dart';
import 'package:app_gringos_massas/pages/stock/stock_page.dart';
import 'package:app_gringos_massas/pages/stock/stock_transaction_form_page.dart';
import 'package:app_gringos_massas/pages/stock/stock_transaction_page.dart';
import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:app_gringos_massas/providers/sale_item_provider.dart';
import 'package:app_gringos_massas/providers/sale_provider.dart';
import 'package:app_gringos_massas/providers/stock_provider.dart';
import 'package:app_gringos_massas/utils/app_routes.dart';
import 'package:app_gringos_massas/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => StockProvider()),
        ChangeNotifierProvider(create: (_) => SaleItemProvider()),
        ChangeNotifierProvider(create: (_) => SaleProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'App Gringo\'s Massas',
        theme: appTheme,
        initialRoute: AppRoutes.HOME,
        routes: {
          AppRoutes.HOME: (ctx) => HomePage(),
          AppRoutes.PRODUCTS: (ctx) => ProductsPage(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormPage(),
          AppRoutes.SALES: (ctx) => SalesPage(),
          AppRoutes.SALE_FORM: (ctx) => SaleFormPage(),
          AppRoutes.STOCK: (ctx) => StockPage(),
          AppRoutes.STOCK_TRANSACTION: (ctx) => StockTransactionPage(),
          AppRoutes.STOCK_TRANSACTION_FORM: (ctx) => StockTransactionFormPage(),
          AppRoutes.REPORTS: (ctx) => ReportsPage(),
        },
      ),
    );
  }
}
