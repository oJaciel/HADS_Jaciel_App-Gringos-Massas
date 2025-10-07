import 'package:app_gringos_massas/providers/sale_provider.dart';
import 'package:app_gringos_massas/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalesPage extends StatelessWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sales = Provider.of<SaleProvider>(context, listen: false).sales;
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
            Flexible(
              child: ListView.builder(
                itemCount: sales.length,
                itemBuilder: (ctx, i) {
                  return Text(sales[i].total.toString());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
