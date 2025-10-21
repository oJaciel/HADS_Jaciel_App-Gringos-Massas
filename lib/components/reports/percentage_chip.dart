import 'package:flutter/material.dart';

class PercentageChip extends StatelessWidget {
  final double percentage; // Ex: 12.5 ou -8.3

  const PercentageChip({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    final isPositive = percentage >= 0;
    final color = isPositive ? Colors.green : Colors.red;
    final icon = isPositive ? Icons.arrow_upward : Icons.arrow_downward;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withOpacity(0.2),
      ),

      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
