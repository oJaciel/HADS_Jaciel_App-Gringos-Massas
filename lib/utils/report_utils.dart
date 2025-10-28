import 'package:app_gringos_massas/models/daily_sale_report.dart';
import 'package:app_gringos_massas/models/sale.dart';

class ReportUtils {
  static get1Week(DateTime date) {
    return date.subtract(Duration(days: 7));
  }

  static get1Month(DateTime date) {
    return DateTime(date.year, date.month - 1, date.day);
  }

  static get1Year(DateTime date) {
    return DateTime(date.year - 1, date.month, date.day);
  }

  static List<Sale> getSalesByPeriod(
    List<Sale> sales,
    DateTime startDate,
    DateTime endDate,
  ) {
    return sales
        .where(
          (sale) => sale.date.isAfter(startDate) && sale.date.isBefore(endDate),
        )
        .toList();
  }

  static double getTotalSalesByPeriod(
    List<Sale> sales,
    DateTime startDate,
    DateTime endDate,
  ) {
    sales = getSalesByPeriod(sales, startDate, endDate);
    double total = 0;
    for (Sale sale in sales) {
      total += sale.total;
    }
    return total;
  }

  static int getSaleCountByPeriod(
    List<Sale> sales,
    DateTime startDate,
    DateTime endDate,
  ) {
    sales = getSalesByPeriod(sales, startDate, endDate);

    return sales.length;
  }

  static List<DailySaleReport> getDailySales(
    List<Sale> sales,
    DateTime startDate,
    DateTime endDate,
  ) {
    List<DailySaleReport> dailySales = [];

    // Garantir que startDate comece à meia-noite e endDate termine às 23:59
    DateTime currentDate = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      // Vendas do dia atual
      final salesOfDay = sales.where((s) {
        final saleDate = s.date;
        return saleDate.year == currentDate.year &&
            saleDate.month == currentDate.month &&
            saleDate.day == currentDate.day;
      }).toList();

      // Somar valores e contar vendas
      final totalValue = salesOfDay.fold<double>(0, (sum, s) => sum + s.total);
      final salesCount = salesOfDay.length;

      // Adicionar ao relatório
      dailySales.add(
        DailySaleReport(
          date: currentDate,
          totalValue: totalValue,
          salesCount: salesCount,
        ),
      );

      // Passar para o próximo dia
      currentDate = currentDate.add(Duration(days: 1));
    }

    //Remove da lista os dias que não tiveram vendas
    dailySales.removeWhere((s) => s.totalValue == 0);

    return dailySales;
  }

  static int getTotalProductsSoldByPeriod(
    List<Sale> sales,
    DateTime startDate,
    DateTime endDate,
  ) {
    sales = getSalesByPeriod(sales, startDate, endDate);

    int totalProducts = 0;

    for (final sale in sales) {
      for (final product in sale.products) {
        totalProducts += product.quantity;
      }
    }

    return totalProducts;
  }

  static double getAverageTicketByPeriod(
  List<Sale> sales,
  DateTime startDate,
  DateTime endDate,
) {
  // Filtra as vendas dentro do período
  sales = getSalesByPeriod(sales, startDate, endDate);

  if (sales.isEmpty) return 0;

  // Soma total das vendas
  final total = sales.fold<double>(0, (sum, s) => sum + s.total);

  // Divide pelo número de vendas
  return total / sales.length;
}

  static double getPercentageLastDays(
    List<Sale> sales,
    Function method, {
    int days = 7,
  }) {
    final now = DateTime.now();

    final endRecent = now;
    final startRecent = now.subtract(Duration(days: days));

    final endPrevious = startRecent;
    final startPrevious = startRecent.subtract(Duration(days: days));

    final totalRecent = method(sales, startRecent, endRecent);
    final totalPrevious = method(sales, startPrevious, endPrevious);

    if (totalPrevious == 0) return 100;
    return ((totalRecent - totalPrevious) / totalPrevious) * 100;
  }
}
