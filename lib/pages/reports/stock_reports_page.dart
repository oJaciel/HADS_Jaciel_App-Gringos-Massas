import 'package:app_gringos_massas/components/reports/custom_report_card.dart';
import 'package:app_gringos_massas/components/reports/report_date_dropdown_button.dart';
import 'package:app_gringos_massas/providers/stock_provider.dart';
import 'package:app_gringos_massas/utils/stock_report_utils.dart';
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

    final mostProduced = StockReportUtils.getMostProducedByPeriod(
      stockProvider.transactions,
      DateTime.now().subtract(Duration(days: dayQuantity)),
      DateTime.now(),
    );

    return SingleChildScrollView(
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
                      content: StockReportUtils.getProducedQuantityByPeriod(
                        stockProvider.transactions,
                        DateTime.now().subtract(Duration(days: dayQuantity)),
                        DateTime.now(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomReportCard(
                      label: 'Mais Produzido',
                      icon: Icons.keyboard_double_arrow_up_rounded,
                      dayQuantity: dayQuantity,
                      content: mostProduced == 'N/A'
                          ? mostProduced
                          : Text(
                              StockReportUtils.getMostProducedByPeriod(
                                stockProvider.transactions,
                                DateTime.now().subtract(
                                  Duration(days: dayQuantity),
                                ),
                                DateTime.now(),
                              ).toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
