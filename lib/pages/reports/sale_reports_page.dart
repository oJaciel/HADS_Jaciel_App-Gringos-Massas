import 'package:app_gringos_massas/components/reports/custom_report_card.dart';
import 'package:app_gringos_massas/components/reports/daily_sales_card.dart';
import 'package:app_gringos_massas/components/reports/report_date_dropdown_button.dart';
import 'package:app_gringos_massas/providers/sale_provider.dart';
import 'package:app_gringos_massas/utils/report_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleReportsPage extends StatefulWidget {
  const SaleReportsPage({super.key});

  @override
  State<SaleReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<SaleReportsPage> {
  int dayQuantity = 1;

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Relatórios de Vendas')),
      body: SingleChildScrollView(
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
                    //Card do valor total das vendas
                    Expanded(
                      child: CustomReportCard(
                        label: 'Entradas',
                        icon: Icons.payments_outlined,
                        dayQuantity: dayQuantity,
                        content: ReportUtils.getTotalSalesByPeriod(
                          saleProvider.sales,
                          DateTime.now().subtract(Duration(days: dayQuantity)),
                          DateTime.now(),
                        ),
                        percent: ReportUtils.getPercentageLastDays(
                          saleProvider.sales,
                          ReportUtils.getTotalSalesByPeriod,
                          days: dayQuantity,
                        ),
                      ),
                    ),
                    //Card da quantidade de vendas
                    Expanded(
                      child: CustomReportCard(
                        label: 'Vendas',
                        icon: Icons.shopping_bag_outlined,
                        dayQuantity: dayQuantity,
                        content: ReportUtils.getSaleCountByPeriod(
                          saleProvider.sales,
                          DateTime.now().subtract(Duration(days: dayQuantity)),
                          DateTime.now(),
                        ),
                        percent: ReportUtils.getPercentageLastDays(
                          saleProvider.sales,
                          ReportUtils.getSaleCountByPeriod,
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
                        content: ReportUtils.getTotalProductsSoldByPeriod(
                          saleProvider.sales,
                          DateTime.now().subtract(Duration(days: dayQuantity)),
                          DateTime.now(),
                        ),
                        percent: ReportUtils.getPercentageLastDays(
                          saleProvider.sales,
                          ReportUtils.getTotalProductsSoldByPeriod,
                          days: dayQuantity,
                        ),
                      ),
                    ),
                    Expanded(
                      child: CustomReportCard(
                        label: 'Média das Vendas',
                        icon: Icons.show_chart_rounded,
                        dayQuantity: dayQuantity,
                        content: ReportUtils.getAverageTicketByPeriod(
                          saleProvider.sales,
                          DateTime.now().subtract(Duration(days: dayQuantity)),
                          DateTime.now(),
                        ),
                        percent: ReportUtils.getPercentageLastDays(
                          saleProvider.sales,
                          ReportUtils.getAverageTicketByPeriod,
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
      ),
    );
  }
}
