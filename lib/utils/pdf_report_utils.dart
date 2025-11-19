import 'dart:io';
import 'package:app_gringos_massas/models/daily_sale_report.dart';
import 'package:app_gringos_massas/models/sale_or_service.dart';
import 'package:app_gringos_massas/utils/app_utils.dart';
import 'package:app_gringos_massas/utils/sale_service_report_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.portrait,
        margin: pw.EdgeInsets.all(16),
        build: (pw.Context context) {
          return [
            pw.Column(
              children: [
                pw.Container(
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
                ),
                pw.ListView.builder(
                  itemCount: dailySales.length,
                  itemBuilder: (context, index) {
                    return pw.Column(
                      children: [
                        pw.SizedBox(height: 2),
                        pw.Divider(),
                        pw.SizedBox(height: 2),
                        pw.Row(
                          children: [
                            pw.Text(
                              DateFormat(
                                'dd/MM',
                              ).format(dailySales[index].date),
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                            pw.Row(
                              children: [
                                pw.Container(
                                  width: 6,
                                  height: 40,
                                  decoration: pw.BoxDecoration(
                                    borderRadius: pw.BorderRadius.circular(3),
                                  ),
                                ),
                                pw.SizedBox(width: 12),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Text(
                                      AppUtils.formatPrice(
                                        dailySales[index].totalValue,
                                      ),
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    pw.Row(
                                      children: [
                                        if (dailySales[index].salesCount > 0)
                                          pw.Text(
                                            dailySales[index].salesCount > 1
                                                ? '${dailySales[index].salesCount} vendas'
                                                : '${dailySales[index].salesCount} venda',
                                            style: pw.TextStyle(fontSize: 14),
                                          ),

                                        if (dailySales[index].salesCount > 0 &&
                                            dailySales[index].serviceCount > 0)
                                          pw.Padding(
                                            padding: pw.EdgeInsets.symmetric(
                                              horizontal: 8,
                                            ),
                                            child: pw.Text(
                                              '|',
                                              style: pw.TextStyle(fontSize: 14),
                                            ),
                                          ),

                                        if (dailySales[index].serviceCount > 0)
                                          pw.Text(
                                            dailySales[index].serviceCount > 1
                                                ? '${dailySales[index].serviceCount} serviços'
                                                : '${dailySales[index].serviceCount} serviço',
                                            style: pw.TextStyle(fontSize: 14),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  },
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
