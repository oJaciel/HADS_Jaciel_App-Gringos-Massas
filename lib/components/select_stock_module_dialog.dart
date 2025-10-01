import 'package:app_gringos_massas/utils/app_routes.dart';
import 'package:flutter/material.dart';

class SelectStockModuleDialog extends StatelessWidget {
  const SelectStockModuleDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        'Selecione o Módulo',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.shelves, color: Theme.of(context).primaryColor),
            title: Text('Saldos em Estoque'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(AppRoutes.STOCK);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.swap_vert_rounded,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Transações de Estoque'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(AppRoutes.STOCK_TRANSACTION);
            },
          ),
        ],
      ),
    );
  }
}
