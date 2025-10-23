import 'package:app_gringos_massas/components/reports/custom_report_card.dart';
import 'package:app_gringos_massas/components/reports/daily_sales_card.dart';
import 'package:app_gringos_massas/providers/sale_provider.dart';
import 'package:app_gringos_massas/utils/report_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  int dayQuantity = 1;

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Relatórios')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              DropdownButton<int>(
                items: [
                  DropdownMenuItem(value: 1, child: Text('Hoje')),
                  DropdownMenuItem(value: 7, child: Text('Últimos 7 dias')),
                  DropdownMenuItem(value: 15, child: Text('Últimos 15 dias')),
                  DropdownMenuItem(value: 30, child: Text('Últimos 30 dias')),
                ],
                elevation: 3,
                padding: EdgeInsets.all(4),
                value: dayQuantity,
                onChanged: (days) {
                  setState(() {
                    dayQuantity = days!;
                  });
                },
              ),
              Row(
                children: [
                  //Card do valor total das vendas
                  Expanded(
                    child: CustomReportCard(
                      label: 'Entradas',
                      icon: Icons.payments_outlined,
                      sales: saleProvider.sales,
                      dayQuantity: dayQuantity,
                      content: ReportUtils.getTotalSalesByPeriod(
                        saleProvider.sales,
                        DateTime.now().subtract(Duration(days: dayQuantity)),
                        DateTime.now(),
                      ),
                      percent: ReportUtils.getPercentageChangeLastDays(
                        saleProvider.sales,
                        days: dayQuantity,
                      ),
                    ),
                  ),
                  //Card da quantidade de vendas
                  Expanded(
                    child: CustomReportCard(
                      label: 'Vendas',
                      icon: Icons.shopping_bag_outlined,
                      sales: saleProvider.sales,
                      dayQuantity: dayQuantity,
                      content: ReportUtils.getSaleCountByPeriod(
                        saleProvider.sales,
                        DateTime.now().subtract(Duration(days: dayQuantity)),
                        DateTime.now(),
                      ),
                      percent: ReportUtils.getPercentageCountLastDays(
                        saleProvider.sales,
                        days: dayQuantity,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              DailySalesCard(dayQuantity),
            ],
          ),
        ),
      ),
    );
  }
}
