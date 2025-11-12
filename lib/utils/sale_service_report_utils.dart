import 'package:app_gringos_massas/models/daily_sale_report.dart';
import 'package:app_gringos_massas/models/sale.dart';
import 'package:app_gringos_massas/models/sale_or_service.dart';
import 'package:app_gringos_massas/models/service.dart';

class SaleServiceReportUtils {
  //Relatórios de Vendas

  // Filtrar itens no período
  // Filtrar itens no período (incluindo o primeiro e o último dia)
  static List<SaleOrService> getItemsByPeriod(
    List<SaleOrService> items,
    DateTime start,
    DateTime end,
  ) {
    // Normaliza as datas para comparar apenas ano/mês/dia
    DateTime normalize(DateTime d) => DateTime(d.year, d.month, d.day);

    final startDate = normalize(start);
    final endDate = normalize(end);

    return items.where((i) {
      final itemDate = normalize(i.date);
      return !itemDate.isBefore(startDate) && !itemDate.isAfter(endDate);
    }).toList();
  }

  // Valor total (vendas + serviços)
  static double getTotalByPeriod(
    List<SaleOrService> items,
    DateTime start,
    DateTime end,
  ) {
    items = getItemsByPeriod(items, start, end);

    double total = 0;

    for (final item in items) {
      if (item.isService) {
        total += (item.data as Service).total;
      } else {
        total += (item.data as Sale).total;
      }
    }
    return total;
  }

  // Contagem (tanto vendas quanto serviços)
  static int getCountByPeriod(
    List<SaleOrService> items,
    DateTime start,
    DateTime end,
  ) {
    items = getItemsByPeriod(items, start, end);
    return items.length;
  }

  // Somente produtos vendidos (serviços não contam)
  static int getProductsSoldByPeriod(
    List<SaleOrService> items,
    DateTime start,
    DateTime end,
  ) {
    items = getItemsByPeriod(items, start, end);

    int total = 0;

    for (final item in items) {
      if (!item.isService) {
        final sale = item.data as Sale;
        for (final p in sale.products) {
          total += p.quantity;
        }
      }
    }
    return total;
  }

  // Ticket médio (vendas + serviços)
  static double getAverageTicket(
    List<SaleOrService> items,
    DateTime start,
    DateTime end,
  ) {
    items = getItemsByPeriod(items, start, end);
    if (items.isEmpty) return 0;

    double total = getTotalByPeriod(items, start, end);

    return total / items.length;
  }

  // Percentual com método genérico
  static double getPercentageLastDays(
    List<SaleOrService> items,
    Function method, {
    int days = 7,
  }) {
    final now = DateTime.now();

    final startRecent = now.subtract(Duration(days: days));
    final endRecent = now;

    final startPrev = startRecent.subtract(Duration(days: days));
    final endPrev = startRecent;

    final recent = method(items, startRecent, endRecent);
    final previous = method(items, startPrev, endPrev);

    if (previous == 0) return 100;

    return ((recent - previous) / previous) * 100;
  }

  // Relatório diário mesclado (vendas + serviços)
  static List<DailySaleReport> getDaily(
    List<SaleOrService> items,
    DateTime start,
    DateTime end,
  ) {
    List<DailySaleReport> list = [];

    DateTime current = DateTime(start.year, start.month, start.day);

    while (!current.isAfter(end)) {
      final itemsOfDay = items.where(
        (i) =>
            i.date.year == current.year &&
            i.date.month == current.month &&
            i.date.day == current.day,
      );

      double total = 0;
      int saleCount = 0;
      int serviceCount = 0;

      for (final item in itemsOfDay) {
        if (item.isService) {
          total += (item.data as Service).total;
          serviceCount++;
        } else {
          total += (item.data as Sale).total;
          saleCount++;
        }
      }

      if (total > 0) {
        list.add(
          DailySaleReport(
            date: current,
            totalValue: total,
            salesCount: saleCount,
            serviceCount: serviceCount,
          ),
        );
      }

      current = current.add(Duration(days: 1));
    }

    return list;
  }
}
