import 'package:flutter/material.dart';

class ReportDateDropdownButton extends StatelessWidget {
  const ReportDateDropdownButton({
    super.key,
    required this.dayQuantity,
    required this.onChanged,
  });

  final int dayQuantity;
  final ValueChanged<int?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_month_rounded,
                color: Theme.of(context).primaryColor,
              ),

              SizedBox(width: 10),

              DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: dayQuantity,
                  onChanged: onChanged,
                  borderRadius: BorderRadius.circular(12),
                  icon: Icon(
                    Icons.arrow_drop_down_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('Hoje')),
                    DropdownMenuItem(value: 7, child: Text('Últimos 7 dias')),
                    DropdownMenuItem(value: 15, child: Text('Últimos 15 dias')),
                    DropdownMenuItem(value: 30, child: Text('Últimos 30 dias')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
