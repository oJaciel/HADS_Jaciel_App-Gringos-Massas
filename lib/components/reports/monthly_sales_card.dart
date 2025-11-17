import 'package:app_gringos_massas/components/reports/daily_sales_chart.dart';
import 'package:app_gringos_massas/components/reports/monthly_sales_overview.dart';
import 'package:app_gringos_massas/models/sale_or_service.dart';
import 'package:app_gringos_massas/providers/sale_provider.dart';
import 'package:app_gringos_massas/providers/service_provider.dart';

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';

class MonthlySalesCard extends StatefulWidget {
  const MonthlySalesCard({super.key});

  @override
  State<MonthlySalesCard> createState() => _MonthlySalesCardState();
}

class _MonthlySalesCardState extends State<MonthlySalesCard> {
  DateTimeRange selectedDates = DateTimeRange(
    start: DateTime(2025),
    end: DateTime.now(),
  );

  DateTime? selectedMonth = DateTime.now();

  bool showSaleReports = true;
  bool showServiceReports = true;

  @override
  void initState() {
    initializeDateFormatting('pt_BR');
    super.initState();
  }

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

    //Filtrando a lista
    List<SaleOrService> filteredList = combinedList.where((item) {
      if (!showSaleReports && !showServiceReports) return false;
      if (!showSaleReports && item.isService == false) return false;
      if (!showServiceReports && item.isService == true) return false;

      return true;
    }).toList();

    DateTime startDate = DateTime(selectedMonth!.year, selectedMonth!.month, 1);
    DateTime endDate = DateTime(
      selectedMonth!.year,
      selectedMonth!.month + 1,
      0,
    );

    return DefaultTabController(
      length: 2,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.calendar_month_rounded,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Vendas - Análise Mensal',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              InkWell(
                onTap: () {
                  showMonthPicker(
                    context: context,
                    initialDate: selectedMonth,
                  ).then((date) {
                    if (date != null) {
                      setState(() {
                        selectedMonth = date;
                      });
                    }
                  });
                },
                child: Chip(
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                      color: Theme.of(context).primaryColor.withOpacity(0.4),
                    ),
                  ),
                  avatar: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.date_range_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 18,
                    ),
                  ),
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        toBeginningOfSentenceCase(
                          DateFormat(
                            'MMMM/yyyy',
                            'pt_BR',
                          ).format(selectedMonth!),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10),

              TabBar(
                tabs: [
                  Tab(text: 'Visão Geral'),
                  Tab(text: 'Gráfico'),
                ],
              ),

              SizedBox(
                height: 250,
                child: TabBarView(
                  children: [
                    SizedBox.expand(
                      child: MonthlySalesOverview(
                        list: filteredList,
                        startDate: startDate,
                        endDate: endDate,
                      ),
                    ),
                    SizedBox.expand(
                      child: DailySalesChart(
                        list: filteredList,
                        startDate: startDate,
                        endDate: endDate,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
