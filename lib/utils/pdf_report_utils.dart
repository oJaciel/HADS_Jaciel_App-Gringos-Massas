import 'dart:io';
import 'package:app_gringos_massas/models/daily_sale_report.dart';
import 'package:app_gringos_massas/models/sale_or_service.dart';
import 'package:app_gringos_massas/utils/app_utils.dart';
import 'package:app_gringos_massas/utils/sale_service_report_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class PdfReportUtils {
  static Future<void> generatePdfReport(
    List<SaleOrService> list,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final pdf = pw.Document();

    List<DailySaleReport> dailySales = SaleServiceReportUtils.getDaily(
      list,
      startDate,
      endDate,
    );

    final totalSalesValue = SaleServiceReportUtils.getTotalByPeriod(
      list,
      startDate,
      endDate,
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.portrait,
        margin: pw.EdgeInsets.all(16),
        header: (context) {
          return pw.Container(
            width: double.infinity,
            decoration: pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(width: 2),
                left: pw.BorderSide(width: 2),
                right: pw.BorderSide(width: 2),
                top: pw.BorderSide(width: 2),
              ),
            ),
            child: pw.Padding(
              padding: pw.EdgeInsets.all(8),
              child: pw.Column(
                children: [
                  pw.Text(
                    'Análise de Vendas',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    '${DateFormat('dd/MM/yyyy').format(startDate)} - ${DateFormat('dd/MM/yyyy').format(endDate)}',
                  ),
                ],
              ),
            ),
          );
        },
        footer: (context) {
          return pw.Column(
            children: [
              pw.Divider(),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 8),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  children: [
                    pw.Text('Gringo\'s Massas'),
                    pw.Spacer(),
                    pw.Text(
                      'Impresso em ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        build: (pw.Context context) {
          return [
            pw.Column(
              children: [
                ...dailySales.map((daily) {
                  return pw.Column(
                    children: [
                      pw.Divider(),
                      pw.Padding(
                        padding: pw.EdgeInsets.symmetric(horizontal: 8),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(
                              DateFormat('dd/MM').format(daily.date),
                              style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.SizedBox(width: 5),
                            pw.Text('|', style: pw.TextStyle(fontSize: 14)),
                            pw.SizedBox(width: 10),
                            pw.Text(
                              AppUtils.formatPrice(daily.totalValue),
                              style: pw.TextStyle(fontSize: 14),
                            ),

                            pw.Spacer(),

                            if (daily.salesCount > 0)
                              pw.Text(
                                daily.salesCount > 1
                                    ? '${daily.salesCount} vendas'
                                    : '${daily.salesCount} venda',
                                style: pw.TextStyle(fontSize: 14),
                              ),
                            if (daily.salesCount > 0 && daily.serviceCount > 0)
                              pw.Padding(
                                padding: pw.EdgeInsets.symmetric(horizontal: 8),
                                child: pw.Text(
                                  '|',
                                  style: pw.TextStyle(fontSize: 14),
                                ),
                              ),
                            if (daily.serviceCount > 0)
                              pw.Text(
                                daily.serviceCount > 1
                                    ? '${daily.serviceCount} serviços'
                                    : '${daily.serviceCount} serviço',
                                style: pw.TextStyle(fontSize: 14),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),

                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Total do Período',
                          style: pw.TextStyle(fontSize: 16),
                        ),
                        pw.Text(
                          AppUtils.formatPrice(totalSalesValue),
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    await shareReport(pdf);
  }

  static Future<void> shareReport(pdf) async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final Uint8List pdfData = await pdf.save();

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/report.pdf');
      await file.writeAsBytes(pdfData);

      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'Relatório Gerado',
          title: 'Compartilhar relatório',
        ),
      );

      if (result.status == ShareResultStatus.success) {
        print("Compartilhado com sucesso");
      } else if (result.status == ShareResultStatus.dismissed) {
        print("Compartilhamento cancelado");
      } else {
        print("Compartilhamento não disponível");
      }
    } else if (kIsWeb ||
        (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    }
  }
}
