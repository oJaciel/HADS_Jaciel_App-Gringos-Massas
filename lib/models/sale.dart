import 'package:app_gringos_massas/models/sale_item.dart';

class Sale {
  final String id;
  final List<SaleItem> products;
  final double total;
  final DateTime date;

  Sale({
    required this.id,
    required this.products,
    required this.total,
    required this.date,
  });
}
