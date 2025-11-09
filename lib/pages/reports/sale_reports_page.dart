import 'package:app_gringos_massas/components/common/custom_filter_chip.dart';
import 'package:app_gringos_massas/components/reports/custom_report_card.dart';
import 'package:app_gringos_massas/components/reports/daily_sales_card.dart';
import 'package:app_gringos_massas/components/reports/report_date_dropdown_button.dart';
import 'package:app_gringos_massas/models/sale_or_service.dart';
import 'package:app_gringos_massas/providers/sale_provider.dart';
import 'package:app_gringos_massas/providers/service_provider.dart';
import 'package:app_gringos_massas/utils/sale_service_report_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleReportsPage extends StatefulWidget {
  const SaleReportsPage({super.key});

  @override
  State<SaleReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<SaleReportsPage> {
  int dayQuantity = 1;

  bool showSaleReports = true;
  bool showServiceReports = true;

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

    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ReportDateDropdownButton(
                dayQuantity: dayQuantity,
                onChanged: (days) {
                  setState(() {
                    dayQuantity = days!;
                  });
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Filtrar:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(width: 10),
                  CustomFilterChip(
                    label: 'Vendas',
                    value: showSaleReports,
                    onSelected: (value) {
                      setState(() {
                        showSaleReports = value;
                      });
                    },
                  ),

                  const SizedBox(width: 10),
                  CustomFilterChip(
                    label: 'Serviços',
                    value: showServiceReports,
                    onSelected: (value) {
                      setState(() {
                        showServiceReports = value;
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: 10),

              Row(
                children: [
                  //Card do valor total das vendas
                  Expanded(
                    child: CustomReportCard(
                      label: 'Entradas',
                      icon: Icons.payments_outlined,
                      dayQuantity: dayQuantity,
                      content: SaleServiceReportUtils.getTotalByPeriod(
                        filteredList,
                        DateTime.now().subtract(Duration(days: dayQuantity)),
                        DateTime.now(),
                      ),
                      percent: SaleServiceReportUtils.getPercentageLastDays(
                        filteredList,
                        SaleServiceReportUtils.getTotalByPeriod,
                        days: dayQuantity,
                      ),
                    ),
                  ),
                  //Card da quantidade de vendas
                  Expanded(
                    child: CustomReportCard(
                      label: 'Registros',
                      icon: Icons.shopping_bag_outlined,
                      dayQuantity: dayQuantity,
                      content: SaleServiceReportUtils.getCountByPeriod(
                        filteredList,
                        DateTime.now().subtract(Duration(days: dayQuantity)),
                        DateTime.now(),
                      ),
                      percent: SaleServiceReportUtils.getPercentageLastDays(
                        filteredList,
                        SaleServiceReportUtils.getCountByPeriod,
                        days: dayQuantity,
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  //Card de total de produtos vendidos
                  Expanded(
                    child: CustomReportCard(
                      label: 'Produtos Vendidos',
                      icon: Icons.shopping_cart_outlined,
                      dayQuantity: dayQuantity,
                      content: SaleServiceReportUtils.getProductsSoldByPeriod(
                        filteredList,
                        DateTime.now().subtract(Duration(days: dayQuantity)),
                        DateTime.now(),
                      ),
                      percent: SaleServiceReportUtils.getPercentageLastDays(
                        filteredList,
                        SaleServiceReportUtils.getProductsSoldByPeriod,
                        days: dayQuantity,
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomReportCard(
                      label: 'Valor Médio',
                      icon: Icons.show_chart_rounded,
                      dayQuantity: dayQuantity,
                      content: SaleServiceReportUtils.getAverageTicket(
                        filteredList,
                        DateTime.now().subtract(Duration(days: dayQuantity)),
                        DateTime.now(),
                      ),
                      percent: SaleServiceReportUtils.getPercentageLastDays(
                        filteredList,
                        SaleServiceReportUtils.getAverageTicket,
                        days: dayQuantity,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              DailySalesCard(),
            ],
          ),
        ),
      ),
    );
  }
}
