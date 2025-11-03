import 'package:app_gringos_massas/components/reports/percentage_chip.dart';
import 'package:app_gringos_massas/utils/app_utils.dart';
import 'package:flutter/material.dart';

class CustomReportCard extends StatelessWidget {
  const CustomReportCard({
    super.key,
    required this.label,
    required this.icon,
    required this.dayQuantity,
    required this.content,
    this.percent = null,
  });

  final String label;
  final IconData icon;
  final int dayQuantity;
  final content;
  final double? percent;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.green, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    overflow: TextOverflow.clip,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            content is Widget
                ? content
                : Text(
                    content is double
                        ? AppUtils.formatPrice(content)
                        : content.toString(),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

            const SizedBox(height: 8),

            if (percent != null) PercentageChip(percentage: percent!),
            SizedBox(height: 2),
            Text(
              dayQuantity == 1 ? 'Hoje' : 'Últimos $dayQuantity dias',
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
