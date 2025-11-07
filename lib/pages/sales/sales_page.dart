import 'package:app_gringos_massas/components/common/custom_filter_chip.dart';
import 'package:app_gringos_massas/components/common/date_divider.dart';
import 'package:app_gringos_massas/components/sales/sale_details_item.dart';
import 'package:app_gringos_massas/components/sales/service_details_item.dart';
import 'package:app_gringos_massas/models/sale_or_service.dart';
import 'package:app_gringos_massas/providers/sale_provider.dart';
import 'package:app_gringos_massas/providers/service_provider.dart';
import 'package:app_gringos_massas/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  bool showSalesOnly = false;
  bool showServicesOnly = false;

  @override
  Widget build(BuildContext context) {
    final sales = Provider.of<SaleProvider>(context).sales;
    final services = Provider.of<ServiceProvider>(context).services;

    List<SaleOrService> combinedList = [
      ...sales.map(
        (sale) => SaleOrService(date: sale.date, data: sale, isService: false),
      ),
      ...services.map(
        (service) =>
            SaleOrService(date: service.date, data: service, isService: true),
      ),
    ];

    combinedList.sort((a, b) => b.date.compareTo(a.date));

    //Filtrando a lista
    List<SaleOrService> filteredList = combinedList.where((item) {
      if (showSalesOnly) return !item.isService;
      if (showServicesOnly) return item.isService;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Vendas'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.REPORTS_OVERVIEW),
            icon: Icon(Icons.analytics_outlined),
          ),
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.SALE_FORM),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.SALE_FORM),
                label: Text('Adicionar Nova Venda'),
                icon: Icon(Icons.add_rounded),
              ),
            ),
            SizedBox(height: 10),
            if (combinedList.any((s) => s.isService) &&
                combinedList.any((s) => s.isService == false))
              Row(
                children: [
                  Text(
                    'Filtrar:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(width: 10),
                  CustomFilterChip(
                    label: 'Vendas',
                    value: showSalesOnly,
                    onSelected: (value) {
                      setState(() {
                        showSalesOnly = value;
                        if (value) showServicesOnly = false;
                      });
                    },
                  ),

                  const SizedBox(width: 10),
                  CustomFilterChip(
                    label: 'Serviços',
                    value: showServicesOnly,
                    onSelected: (value) {
                      setState(() {
                        showServicesOnly = value;
                        if (value) showSalesOnly = false;
                      });
                    },
                  ),
                ],
              ),

            SizedBox(height: 10),

            Flexible(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (ctx, index) {
                  final item = filteredList[index];
                  return Column(
                    children: [
                      DateDivider(index: index, list: filteredList),
                      if (item.isService)
                        ServiceDetailsItem(item.data)
                      else
                        SaleDetailsItem(item.data),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
