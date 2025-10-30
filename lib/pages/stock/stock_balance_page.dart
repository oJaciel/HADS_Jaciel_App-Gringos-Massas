import 'package:app_gringos_massas/components/stock/stock_page_item.dart';
import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StockBalancePage extends StatelessWidget {
  const StockBalancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductProvider>(context);
    final products = productsProvider.activeProducts;

    return products.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(8),
            child: SafeArea(
              child: Column(
                children: [
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
                  Text('*Listando somente os itens ativos'),
                ],
              ),
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
          );
  }
}
