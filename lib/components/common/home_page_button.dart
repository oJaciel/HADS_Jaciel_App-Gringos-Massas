import 'package:flutter/material.dart';

class HomePageButton extends StatelessWidget {
  const HomePageButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.15,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Card(
          elevation: 3,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: onTap,
            child: Row(
              children: [
                Expanded(flex: 2, child: Icon(icon, size: 32)),
                Expanded(
                  flex: 4,
                  child: Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Expanded(flex: 1, child: Icon(Icons.arrow_forward_ios_rounded)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
