import 'package:app_gringos_massas/utils/app_routes.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Image.asset(
              'assets/logo.png',
              width: MediaQuery.of(context).size.width * 0.4,
            ),
            Divider(color: colorScheme.primary),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.sell_rounded, color: colorScheme.primary),
                      SizedBox(width: 6),
                      Text(
                        'Produtos',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.list_rounded,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      'Gerenciar Produtos',
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(AppRoutes.PRODUCTS);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.add, color: colorScheme.primary),
                    title: Text(
                      'Novo Produto',
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORM);
                    },
                  ),
                  Divider(color: colorScheme.primary),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.shopping_cart_rounded,
                        color: colorScheme.primary,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Vendas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.receipt_long_rounded,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      'Gerenciar Vendas',
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(AppRoutes.SALES);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.add_shopping_cart_rounded,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      'Nova Venda',
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    onTap: () {},
                  ),
                  Divider(color: colorScheme.primary),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2_rounded,
                        color: colorScheme.primary,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Estoque',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Icon(Icons.shelves, color: colorScheme.primary),
                    title: Text(
                      'Saldos em Estoque',
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(AppRoutes.STOCK);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.swap_vert_rounded,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      'Transações de Estoque',
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    onTap: () => Navigator.of(
                      context,
                    ).pushNamed(AppRoutes.STOCK_TRANSACTION),
                  ),
                  Divider(color: colorScheme.primary),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.analytics_rounded, color: colorScheme.primary),
                      SizedBox(width: 6),
                      Text(
                        'Relatórios',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.add_chart_rounded,
                      color: colorScheme.primary,
                    ),
                    title: Text(
                      'Gerar Relatório',
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(AppRoutes.REPORTS);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
