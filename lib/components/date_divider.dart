import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class DateDivider extends StatelessWidget {
  final int index;
  final List list;

  const DateDivider({
    required this.index,
    required this.list,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentDate = list[index].date as DateTime;
    final previousDate =
        index > 0 ? list[index - 1].date as DateTime : null;

    // Só mostra se for o primeiro item do dia ou se a data mudou
    if (previousDate != null &&
        currentDate.year == previousDate.year &&
        currentDate.month == previousDate.month &&
        currentDate.day == previousDate.day) {
      return SizedBox.shrink();
    }

    final formattedDate = DateFormat('dd/MM/yyyy').format(currentDate);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.calendar_today_rounded, size: 18, color: Colors.grey[700]),
          SizedBox(width: 8),
          Text(
            formattedDate,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}

