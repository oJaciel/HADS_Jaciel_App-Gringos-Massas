class DailySaleReport {
  final DateTime date;
  final double totalValue;
  final int salesCount;
  final int serviceCount;

  DailySaleReport({
    required this.date,
    required this.totalValue,
    required this.salesCount,
    required this.serviceCount,
  });
}
