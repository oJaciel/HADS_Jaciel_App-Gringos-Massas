import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DailyDateRangePicker extends StatelessWidget {
  const DailyDateRangePicker({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onSubmit,
  });

  final DateTime startDate;
  final DateTime endDate;
  final dynamic Function(Object?) onSubmit;

  @override
  Widget build(BuildContext context) {
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
                onSubmit: onSubmit,
              ),
            ),
          );
        },
      );
    }

    return InkWell(
      onTap: _showDateRangePicker,
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
            Text(DateFormat('dd/MM/yyyy').format(startDate)),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, size: 18),
            const SizedBox(width: 8),
            Text(DateFormat('dd/MM/yyyy').format(endDate)),
          ],
        ),
      ),
    );
  }
}
