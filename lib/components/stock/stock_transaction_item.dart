import 'package:app_gringos_massas/components/dialogs/delete_alert_dialog.dart';
import 'package:app_gringos_massas/models/stock_transaction.dart';
import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:app_gringos_massas/providers/stock_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StockTransactionItem extends StatelessWidget {
  const StockTransactionItem(this.transaction, {super.key});

  final StockTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: ListTile(
        leading: Icon(
          transaction.type == TransactionType.entry
              ? Icons.arrow_upward_outlined
              : Icons.arrow_downward_outlined,
          color: transaction.type == TransactionType.entry
              ? Colors.green
              : Colors.red,
        ),
        title: Row(
          children: [
            Text(DateFormat('dd/MM').format(transaction.date)),
            SizedBox(width: 4),
            Icon(Icons.circle, size: 4),
            SizedBox(width: 4),
            Text(
              DateFormat('HH:mm').format(transaction.date),
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Produto:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text(transaction.product.name),
              ],
            ),
            Row(
              children: [
                Text(
                  'Quantidade:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 4),
                Text(transaction.quantity.toString()),
              ],
            ),
            Row(
              children: [
                Text('Tipo:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text(
                  transaction.type == TransactionType.entry
                      ? 'Entrada'
                      : 'Saída',
                ),
              ],
            ),
          ],
        ),
        trailing: SizedBox(
          height: 30,
          width: 30,
          child: IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (ctx) => DeleteAlertDialog(
                title: 'Excluir',
                content: 'Deseja realmente excluir?',
                deleteMethod: () async {
                  final stockProvider = Provider.of<StockProvider>(
                    context,
                    listen: false,
                  );
                  final productProvider = Provider.of<ProductProvider>(
                    context,
                    listen: false,
                  );

                  await stockProvider.removeTransaction(
                    context,
                    productProvider,
                    transaction,
                  );
                },
              ),
            ),
            icon: Icon(Icons.delete_rounded, color: Colors.red),
            iconSize: 30,
          ),
        ),
      ),
    );
  }
}
