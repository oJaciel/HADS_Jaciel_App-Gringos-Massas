import 'package:app_gringos_massas/models/daily_sale_report.dart';
import 'package:app_gringos_massas/models/sale_or_service.dart';
import 'package:app_gringos_massas/utils/app_utils.dart';
import 'package:app_gringos_massas/utils/sale_service_report_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportCardList extends StatelessWidget {
  const ReportCardList({
    super.key,
    required this.list,
    required this.startDate,
    required this.endDate,
  });

  final List<SaleOrService> list;
  final DateTime startDate;
  final DateTime endDate;

  @override
  Widget build(BuildContext context) {
    List<DailySaleReport> dailySales = SaleServiceReportUtils.getDaily(
      list,
      startDate,
      endDate,
    );

    return ListView.builder(
      itemCount: dailySales.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Text(
                DateFormat('dd/MM').format(dailySales[index].date),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            title: Row(
              children: [
                Container(
                  width: 6,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppUtils.formatPrice(dailySales[index].totalValue),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Row(
                      children: [
                        if (dailySales[index].salesCount > 0)
                          Text(
                            dailySales[index].salesCount > 1
                                ? '${dailySales[index].salesCount} vendas'
                                : '${dailySales[index].salesCount} venda',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 14,
                            ),
                          ),

                        if (dailySales[index].salesCount > 0 &&
                            dailySales[index].serviceCount > 0)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '|',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                              ),
                            ),
                          ),

                        if (dailySales[index].serviceCount > 0)
                          Text(
                            dailySales[index].serviceCount > 1
                                ? '${dailySales[index].serviceCount} serviços'
                                : '${dailySales[index].serviceCount} serviço',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
