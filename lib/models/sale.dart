import 'package:app_gringos_massas/models/sale_item.dart';
import 'package:app_gringos_massas/providers/sale_provider.dart';

class Sale {
  final String id;
  final List<SaleItem> products;
  final double total;
  final String? clientName;
  final PaymentMethod? paymentMethod;
  final String date;

  Sale({
    required this.id,
    required this.products,
    required this.total,
    required this.date,
    this.clientName,
    this.paymentMethod,
  });
}
