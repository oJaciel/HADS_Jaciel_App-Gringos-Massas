import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class MonthlyDatePicker extends StatefulWidget {
  const MonthlyDatePicker({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onChanged,
  });

  final DateTime startDate;
  final DateTime endDate;
  final void Function(DateTime start, DateTime end) onChanged;

  @override
  State<MonthlyDatePicker> createState() => _MonthlyDatePickerState();
}

class _MonthlyDatePickerState extends State<MonthlyDatePicker> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showMonthPicker(context: context, initialDate: widget.startDate).then((
          date,
        ) {
          if (date != null) {
            setState(() {
              final start = DateTime(date.year, date.month, 1);
              final end = DateTime(date.year, date.month + 1, 0);

              widget.onChanged(start, end);
            });
          }
        });
      },
      child: Chip(
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
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
            Text(
              toBeginningOfSentenceCase(
                DateFormat('MMMM/yyyy', 'pt_BR').format(widget.startDate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
