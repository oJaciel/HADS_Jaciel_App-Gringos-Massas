import 'package:app_gringos_massas/components/stock_page_item.dart';
import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:app_gringos_massas/providers/stock_provider.dart';
import 'package:app_gringos_massas/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StockPage extends StatelessWidget {
  const StockPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final products = provider.activeProducts;
    return Scaffold(
      appBar: AppBar(title: Text('Estoque')),
      body: products.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.STOCK_TRANSACTION_FORM,
                            arguments: TransactionType.entry,
                          );
                        },
                        label: Text('Nova Entrada'),
                        icon: Icon(Icons.arrow_upward_outlined),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.STOCK_TRANSACTION_FORM,
                            arguments: TransactionType.out,
                          );
                        },
                        label: Text('Nova Saída'),
                        icon: Icon(Icons.arrow_downward_outlined),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Saldos em Estoque',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Flexible(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return StockPageItem(products[index]);
                      },
                      itemCount: products.length,
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Nenhum produto encontrado',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(height: 16),
                  Icon(Icons.error_outline_rounded, size: 24),
                  SizedBox(height: 16),
                  Text('Adicione ou ative produtos para visualizar o estoque!'),
                ],
              ),
            ),
    );
  }
}
