import 'package:app_gringos_massas/models/product.dart';
import 'package:app_gringos_massas/providers/stock_provider.dart';

class StockTransaction {
  final String id;
  final Product product;
  final int quantity;
  final TransactionType type;
  final DateTime date;

  StockTransaction({
    required this.id,
    required this.product,
    required this.quantity,
    required this.type,
    required this.date,
  });
}
