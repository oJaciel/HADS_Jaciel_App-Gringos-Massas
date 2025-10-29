import 'package:app_gringos_massas/utils/app_routes.dart';
import 'package:flutter/material.dart';

class SelectReportsModuleDialog extends StatelessWidget {
  const SelectReportsModuleDialog({super.key});

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
            leading: Icon(
              Icons.assessment_outlined,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Relatórios de Vendas'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(AppRoutes.SALE_REPORTS);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.insert_chart_outlined_rounded,
              color: Theme.of(context).primaryColor,
            ),
            title: Text('Relatórios de Estoque'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(AppRoutes.STOCK_REPORTS);
            },
          ),
        ],
      ),
    );
  }
}
