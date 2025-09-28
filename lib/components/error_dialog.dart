import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key, required this.content});
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [Icon(Icons.error), SizedBox(width: 8), Text('Erro!')],
      ),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Ok'),
        ),
      ],
    );
  }
}
