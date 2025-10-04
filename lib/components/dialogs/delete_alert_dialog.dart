import 'package:flutter/material.dart';

class DeleteAlertDialog extends StatelessWidget {
  const DeleteAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.deleteMethod,
  });

  final String title;
  final String content;
  final void Function() deleteMethod;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(content),
      title: Row(
        children: [Icon(Icons.delete), SizedBox(width: 8), Text(title)],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Não'),
        ),
        TextButton(
          onPressed: () {
            deleteMethod();
            Navigator.of(context).pop();
          },
          child: Text('Sim'),
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll(Colors.red),
          ),
        ),
      ],
    );
  }
}
