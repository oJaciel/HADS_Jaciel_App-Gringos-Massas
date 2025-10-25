import 'package:app_gringos_massas/models/daily_sale_report.dart';
import 'package:app_gringos_massas/providers/sale_provider.dart';
import 'package:app_gringos_massas/utils/app_utils.dart';
import 'package:app_gringos_massas/utils/report_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DailySalesChart extends StatelessWidget {
  const DailySalesChart({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;

  @override
  Widget build(BuildContext context) {
    List<DailySaleReport> dailySales = ReportUtils.getDailySales(
      Provider.of<SaleProvider>(context, listen: false).sales,
      startDate,
      endDate,
    );

    //Ordenando por ordem de data
    dailySales.sort((a, b) => a.date.compareTo(b.date));

    //Convertendo a lista em pontos do gráfico
    final chartSpots = dailySales.asMap().entries.map((entry) {
      int index = entry.key;
      DailySaleReport report = entry.value;
      return FlSpot(index.toDouble(), report.totalValue);
    }).toList();

    //Formatando as datas para o gráfico
    final dateLabels = dailySales
        .map((d) => DateFormat('dd/MM').format(d.date))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LineChart(
        LineChartData(
          minX: 0,
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      value.toStringAsFixed(0),
                      style: const TextStyle(fontSize: 11),
                    ),
                  );
                },
              ),
            ),

            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index < 0 || index >= dateLabels.length) {
                    return const SizedBox.shrink();
                  }
                  return SideTitleWidget(
                    meta: meta,
                    child: Transform.rotate(
                      angle: -0.6,
                      child: Text(
                        dateLabels[index],
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(color: Colors.grey),
              left: BorderSide(color: Colors.grey),
            ),
          ),
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final dailySale = dailySales[spot.x.toInt()];
                  final totalValue = AppUtils.formatPrice(dailySale.totalValue);
                  return LineTooltipItem(
                    '${DateFormat('dd/MM').format(dailySale.date)}\n',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: '$totalValue\n',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                        text: 'Vendas: ${dailySale.salesCount}',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: chartSpots,
              isStrokeCapRound: true,
              isCurved: false,
              color: Theme.of(context).primaryColor,
              barWidth: 3,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Theme.of(context).primaryColor.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
