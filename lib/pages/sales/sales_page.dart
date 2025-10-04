import 'package:app_gringos_massas/utils/app_routes.dart';
import 'package:flutter/material.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vendas')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.SALE_FORM),
                label: Text('Adicionar Nova Venda'),
                icon: Icon(Icons.add_rounded),
              ),
            ),
            SizedBox(height: 6),
            Flexible(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
