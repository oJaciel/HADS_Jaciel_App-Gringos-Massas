import 'dart:convert';

import 'package:app_gringos_massas/models/service.dart';
import 'package:app_gringos_massas/providers/sale_provider.dart';
import 'package:app_gringos_massas/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';

class ServiceProvider with ChangeNotifier {
  final List<Service> _services = [];

  List<Service> get services => [..._services];

  int get servicesCount => _services.length;

  Future<void> addService(
    BuildContext context,
    String? description,
    String? clientName,
    PaymentMethod? paymentMethod,
    double total,
    DateTime date,
  ) async {
    final response = await http.post(
      Uri.parse('${Constants.SERVICE_BASE_URL}.json'),
      body: jsonEncode({
        if (description!.isNotEmpty && description != '')
          "description": description,
        if (clientName!.isNotEmpty && clientName != '')
          "clientName": clientName,
        "paymentMethod": paymentMethod?.name,
        "total": total,
        "date": date.toIso8601String(),
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception('Erro ao gravar serviço: ${response.body}');
    }

    final serviceId = jsonDecode(response.body)['name'];

    _services.add(
      Service(
        id: serviceId,
        description: description,
        total: total,
        clientName: clientName,
        paymentMethod: paymentMethod,
        date: date,
      ),
    );

    //Ordena a lista por ordem de data
    _services.sort((a, b) => b.date.compareTo(a.date));
  }
}
