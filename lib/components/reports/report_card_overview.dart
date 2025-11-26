import 'package:app_gringos_massas/models/daily_sale_report.dart';
import 'package:app_gringos_massas/models/sale_or_service.dart';
import 'package:app_gringos_massas/utils/app_utils.dart';
import 'package:app_gringos_massas/utils/sale_service_report_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportCardOverview extends StatelessWidget {
  const ReportCardOverview({
    super.key,
    required this.list,
    required this.startDate,
    required this.endDate, required this.isMonthly,
  });

  final List<SaleOrService> list;
  final DateTime startDate;
  final DateTime endDate;
  final bool isMonthly;

  @override
  Widget build(BuildContext context) {
    DailySaleReport monthSales = SaleServiceReportUtils.getMonthly(
      list,
      startDate,
      endDate,
    );

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ====== VALOR TOTAL DO MÊS ======
              Text(
                AppUtils.formatPrice(monthSales.totalValue),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "Faturamento total do período",
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),

              const SizedBox(height: 16),

              Container(height: 1, color: Colors.grey[300]),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          monthSales.salesCount.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          monthSales.salesCount == 1 ? "venda" : "vendas",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(width: 1, height: 40, color: Colors.grey[300]),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          monthSales.serviceCount.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          monthSales.serviceCount == 1 ? "serviço" : "serviços",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Spacer(),

              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  !isMonthly ? "Período: ${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}" :
                  "Período: ${DateFormat('MM/yyyy').format(startDate)}",
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
