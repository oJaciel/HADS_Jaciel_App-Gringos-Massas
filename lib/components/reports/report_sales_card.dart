import 'package:app_gringos_massas/components/common/custom_filter_chip.dart';
import 'package:app_gringos_massas/components/reports/daily_date_range_picker.dart';
import 'package:app_gringos_massas/components/reports/report_card_chart.dart';
import 'package:app_gringos_massas/components/reports/report_card_list.dart';
import 'package:app_gringos_massas/components/reports/monthly_date_picker.dart';
import 'package:app_gringos_massas/components/reports/report_card_overview.dart';
import 'package:app_gringos_massas/models/sale_or_service.dart';
import 'package:app_gringos_massas/providers/sale_provider.dart';
import 'package:app_gringos_massas/providers/service_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:app_gringos_massas/utils/pdf_report_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ReportSalesCard extends StatefulWidget {
  const ReportSalesCard({super.key});

  @override
  State<ReportSalesCard> createState() => _DailySalesCardState();
}

class _DailySalesCardState extends State<ReportSalesCard> {
  DateTimeRange selectedDates = DateTimeRange(
    start: DateTime(2025),
    end: DateTime.now(),
  );

  DateTime? startDate = DateTime.now().subtract(Duration(days: 7));
  DateTime? endDate = DateTime.now();

  bool isMonthly = false;
  bool showSaleReports = true;
  bool showServiceReports = true;

  @override
  void initState() {
    initializeDateFormatting('pt_BR');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sales = Provider.of<SaleProvider>(context).sales;
    final services = Provider.of<ServiceProvider>(context).services;

    List<SaleOrService> combinedList = [
      ...sales.map(
        (sale) => SaleOrService(date: sale.date, data: sale, isService: false),
      ),
      ...services.map(
        (service) =>
            SaleOrService(date: service.date, data: service, isService: true),
      ),
    ];

    //Filtrando a lista
    List<SaleOrService> filteredList = combinedList.where((item) {
      if (!showSaleReports && !showServiceReports) return false;
      if (!showSaleReports && item.isService == false) return false;
      if (!showServiceReports && item.isService == true) return false;

      return true;
    }).toList();

    return DefaultTabController(
      length: 3,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      !isMonthly
                          ? Icons.date_range_rounded
                          : Icons.calendar_month_rounded,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    !isMonthly
                        ? 'Vendas - Análise Diária'
                        : 'Vendas - Análise Mensal',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isMonthly = !isMonthly;
                        startDate = DateTime(
                          startDate!.year,
                          startDate!.month,
                          1,
                        );
                        endDate = DateTime(
                          endDate!.year,
                          endDate!.month + 1,
                          0,
                        );
                      });
                    },
                    icon: Icon(Icons.change_circle_outlined),
                  ),
                  IconButton(
                    onPressed: () => PdfReportUtils.generatePdfReport(
                      filteredList,
                      startDate!,
                      endDate!,
                    ),
                    icon: Icon(Icons.picture_as_pdf_rounded),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              !isMonthly
                  ? DailyDateRangePicker(
                      startDate: startDate!,
                      endDate: endDate!,
                      onSubmit: (Object? value) {
                        if (value is PickerDateRange) {
                          setState(() {
                            startDate = value.startDate;
                            endDate = value.endDate;
                          });
                        }
                        Navigator.pop(context);
                      },
                    )
                  : MonthlyDatePicker(
                      startDate: startDate!,
                      endDate: endDate!,
                      onChanged: (start, end) {
                        setState(() {
                          startDate = start;
                          endDate = end;
                        });
                      },
                    ),

              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomFilterChip(
                    label: 'Vendas',
                    value: showSaleReports,
                    onSelected: (value) {
                      setState(() {
                        showSaleReports = value;
                      });
                    },
                  ),

                  const SizedBox(width: 10),
                  CustomFilterChip(
                    label: 'Serviços',
                    value: showServiceReports,
                    onSelected: (value) {
                      setState(() {
                        showServiceReports = value;
                      });
                    },
                  ),
                ],
              ),

              SizedBox(height: 10),

              TabBar(
                tabs: [
                  Tab(text: 'Visão Geral'),
                  Tab(text: 'Lista'),
                  Tab(text: 'Gráfico'),
                ],
              ),

              SizedBox(
                height: 250,
                child: TabBarView(
                  children: [
                    SizedBox.expand(
                      child: ReportCardOverview(
                        list: filteredList,
                        startDate: startDate!,
                        endDate: endDate!,
                        isMonthly: isMonthly,
                      ),
                    ),
                    ReportCardList(
                      list: filteredList,
                      startDate: startDate!,
                      endDate: endDate!,
                    ),
                    SizedBox.expand(
                      child: ReportCardChart(
                        list: filteredList,
                        startDate: startDate!,
                        endDate: endDate!,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
