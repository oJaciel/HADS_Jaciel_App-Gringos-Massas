import 'package:app_gringos_massas/models/daily_sale_report.dart';
import 'package:app_gringos_massas/models/sale.dart';
import 'package:app_gringos_massas/models/stock_transaction.dart';
import 'package:app_gringos_massas/providers/stock_provider.dart';

class ReportUtils {
  //Relatórios de Vendas

  //Obter lista de vendas no período
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

  //Obter valor total das vendas no período
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

  //Obter quantidade de vendas no período
  static int getSaleCountByPeriod(
    List<Sale> sales,
    DateTime startDate,
    DateTime endDate,
  ) {
    sales = getSalesByPeriod(sales, startDate, endDate);

    return sales.length;
  }

  //Obter valor e quantidade das vendas no período por dia (lista)
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

  //Obter a quantidade de produtos vendidos no período
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

  //Obter o valor médio das vendas no período
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

  // Relatórios de estoque

  //Obter a lista de transações no período
  static List<StockTransaction> getTransactionsByPeriod(
    List<StockTransaction> transactions,
    DateTime startDate,
    DateTime endDate,
  ) {
    return transactions
        .where(
          (transaction) =>
              transaction.date.isAfter(startDate) &&
              transaction.date.isBefore(endDate),
        )
        .toList();
  }

  //Obter a quantidade total produzida no período
  static int getProducedQuantityByPeriod(
    List<StockTransaction> transactions,
    DateTime startDate,
    DateTime endDate,
  ) {
    List<StockTransaction> filteredTransactions = getTransactionsByPeriod(
      transactions,
      startDate,
      endDate,
    );

    int producedQuantity = 0;
    for (StockTransaction transaction in filteredTransactions) {
      if (transaction.type == TransactionType.entry) {
        producedQuantity += transaction.quantity;
      }
    }
    return producedQuantity;
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
