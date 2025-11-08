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

  Future<void> loadServices() async {
    _services.clear();

    final response = await http.get(
      Uri.parse('${Constants.SERVICE_BASE_URL}.json'),
    );

    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((serviceId, serviceData) {
      _services.add(
        Service(
          id: serviceId,
          description: serviceData['description'] ?? '',
          total: serviceData['total'],
          clientName: serviceData['clientName'] ?? '',
          paymentMethod: serviceData['paymentMethod'] != null
              ? PaymentMethod.values.firstWhere(
                  (e) => e.name == serviceData['paymentMethod'],
                )
              : null,
          date: DateTime.parse(serviceData['date']),
        ),
      );
    });

    //Ordena a lista por ordem de data
    _services.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

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

    Navigator.of(context).pop();

    await loadServices();

    //Ordena a lista por ordem de data
    _services.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> updateService(Service service) async {
    final serviceIndex = _services.indexWhere((s) => s.id == service.id);

    if (serviceIndex >= 0) {
      await http.patch(
        Uri.parse('${Constants.SERVICE_BASE_URL}/${service.id}.json'),
        body: jsonEncode({
          if (service.description!.isNotEmpty && service.description != '')
            "description": service.description,
          if (service.clientName!.isNotEmpty && service.clientName != '')
            "clientName": service.clientName,
          "paymentMethod": service.paymentMethod?.name,
          "total": service.total,
          "date": service.date.toIso8601String(),
        }),
      );

      _services[serviceIndex] = service;

      _services.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
    }
  }

  Future<void> removeService(Service service) async {
    final serviceIndex = _services.indexWhere((s) => s.id == service.id);

    if (serviceIndex < 0) return;

    final response = await http.delete(
      Uri.parse('${Constants.SERVICE_BASE_URL}/${service.id}.json'),
    );

    if (response.statusCode >= 400) {
      throw Exception('Erro ao excluir serviço: ${response.body}');
    }

    _services.removeAt(serviceIndex);
    notifyListeners();
  }
}
