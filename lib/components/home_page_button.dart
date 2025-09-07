import 'package:flutter/material.dart';

class HomePageButton extends StatelessWidget {
  const HomePageButton({
    super.key,
    required this.title,
    required this.icon,
    required this.route,
  });

  final String title;
  final Icon icon;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: () => Navigator.of(context).pushNamed(route),
        label: Text(title),
        icon: icon,
      ),
    );
  }
}
