import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:app_gringos_massas/providers/sale_provider.dart';
import 'package:app_gringos_massas/providers/service_provider.dart';
import 'package:app_gringos_massas/providers/stock_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class GeneralProvider with ChangeNotifier {
  Future<void> loadDatabase(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false).loadProducts();
    await Provider.of<StockProvider>(context, listen: false).loadTransactions();
    await Provider.of<SaleProvider>(context, listen: false).loadSales();
    await Provider.of<ServiceProvider>(context, listen: false).loadServices();
  }
}
