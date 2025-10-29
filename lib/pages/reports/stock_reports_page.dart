import 'package:app_gringos_massas/components/reports/custom_report_card.dart';
import 'package:app_gringos_massas/components/reports/report_date_dropdown_button.dart';
import 'package:app_gringos_massas/providers/stock_provider.dart';
import 'package:app_gringos_massas/utils/report_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StockReportsPage extends StatefulWidget {
  const StockReportsPage({super.key});

  @override
  State<StockReportsPage> createState() => _StockReportsPageState();
}

class _StockReportsPageState extends State<StockReportsPage> {
  int dayQuantity = 1;

  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Relatórios de Estoque')),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
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
                    Expanded(
                      child: CustomReportCard(
                        label: 'Qtde. Produzida',
                        icon: Icons.factory_outlined,
                        dayQuantity: dayQuantity,
                        content: ReportUtils.getProducedQuantityByPeriod(
                          stockProvider.transactions,
                          DateTime.now().subtract(Duration(days: dayQuantity)),
                          DateTime.now(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
