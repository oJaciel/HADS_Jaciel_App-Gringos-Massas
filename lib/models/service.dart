import 'package:app_gringos_massas/providers/sale_provider.dart';

class Service {
  final String id;
  final double total;
  final String? description;
  final String? clientName;
  final PaymentMethod? paymentMethod;
  final DateTime date;

  Service({
    required this.id,
    required this.total,
    this.description,
    this.clientName,
    this.paymentMethod,
    required this.date,
  });
}
