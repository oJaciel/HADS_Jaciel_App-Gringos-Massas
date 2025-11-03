import 'package:app_gringos_massas/models/product.dart';
import 'package:app_gringos_massas/models/stock_transaction.dart';
import 'package:app_gringos_massas/providers/stock_provider.dart';

class StockReportUtils {
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

  static String getMostProducedByPeriod(
    List<StockTransaction> transactions,
    DateTime startDate,
    DateTime endDate,
  ) {
    final filteredTransactions = transactions.where((t) {
      return t.date.isAfter(startDate) &&
          t.date.isBefore(endDate) &&
          t.type == TransactionType.entry;
    }).toList();

    if (filteredTransactions.isEmpty) {
      return 'N/A';
    }

    final Map<Product, int> producedByProduct = {};

    for (final transaction in filteredTransactions) {
      producedByProduct[transaction.product] =
          (producedByProduct[transaction.product] ?? 0) +
          transaction.quantity;
    }

    
    final mostProduced = producedByProduct.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );

    return '${mostProduced.key.name} Quantidade: ${mostProduced.value}';
  }
}
