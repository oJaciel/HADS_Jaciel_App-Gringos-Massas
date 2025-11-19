import 'package:app_gringos_massas/components/common/custom_filter_chip.dart';
import 'package:app_gringos_massas/components/reports/daily_sales_chart.dart';
import 'package:app_gringos_massas/components/reports/daily_sales_list.dart';
import 'package:app_gringos_massas/models/sale_or_service.dart';
import 'package:app_gringos_massas/providers/sale_provider.dart';
import 'package:app_gringos_massas/providers/service_provider.dart';
import 'package:app_gringos_massas/utils/app_utils.dart';
import 'package:app_gringos_massas/utils/pdf_report_utils.dart';
import 'package:app_gringos_massas/utils/sale_service_report_utils.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DailySalesCard extends StatefulWidget {
  const DailySalesCard({super.key});

  @override
  State<DailySalesCard> createState() => _DailySalesCardState();
}

class _DailySalesCardState extends State<DailySalesCard> {
  DateTimeRange selectedDates = DateTimeRange(
    start: DateTime(2025),
    end: DateTime.now(),
  );

  DateTime? startDate = DateTime.now().subtract(Duration(days: 7));
  DateTime? endDate = DateTime.now();

  bool showSaleReports = true;
  bool showServiceReports = true;

  void _showDateRangePicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.all(8),
          content: SizedBox(
            width: 350,
            height: 380,
            child: SfDateRangePicker(
              selectionShape: DateRangePickerSelectionShape.rectangle,
              headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: Colors.white,
              ),
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.range,
              backgroundColor: Colors.white,
              minDate: DateTime(2025),
              maxDate: DateTime.now(),
              initialSelectedRange: PickerDateRange(startDate, endDate),
              showActionButtons: true,
              onCancel: () {
                Navigator.pop(context);
              },
              onSubmit: (Object? value) {
                if (value is PickerDateRange) {
                  setState(() {
                    startDate = value.startDate;
                    endDate = value.endDate;
                  });
                }
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
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

    final totalSalesValue = SaleServiceReportUtils.getTotalByPeriod(
      filteredList,
      startDate!,
      endDate!,
    );

    return DefaultTabController(
      length: 2,
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
                      Icons.calendar_month_rounded,
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Vendas - Análise Diária',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Spacer(),
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

              InkWell(
                onTap: _showDateRangePicker,
                child: Chip(
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  backgroundColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: BorderSide(
                      color: Theme.of(context).primaryColor.withOpacity(0.4),
                    ),
                  ),
                  avatar: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.date_range_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 18,
                    ),
                  ),
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(DateFormat('dd/MM/yyyy').format(startDate!)),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                      const SizedBox(width: 8),
                      Text(DateFormat('dd/MM/yyyy').format(endDate!)),
                    ],
                  ),
                ),
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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Valor total do período:',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(width: 6),
                  Text(
                    AppUtils.formatPrice(totalSalesValue),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),

              SizedBox(height: 10),

              TabBar(
                tabs: [
                  Tab(text: 'Lista'),
                  Tab(text: 'Gráfico'),
                ],
              ),

              SizedBox(
                height: 250,
                child: TabBarView(
                  children: [
                    DailySalesList(
                      list: filteredList,
                      startDate: startDate!,
                      endDate: endDate!,
                    ),
                    SizedBox.expand(
                      child: DailySalesChart(
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
