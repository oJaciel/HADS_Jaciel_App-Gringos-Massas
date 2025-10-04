import 'package:app_gringos_massas/components/delete_alert_dialog.dart';
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
    final formattedHour = DateFormat('HH:mm').format(transaction.date);

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
            Text(
              transaction.product.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Icon(
              Icons.watch_later_rounded,
              size: 16,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: 4),
            Text(
              formattedHour,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quantidade: ${transaction.quantity}'),
            Text(
              'Tipo: ${transaction.type == TransactionType.entry ? 'Entrada' : 'Saída'}',
            ),
          ],
        ),

        trailing: IconButton(
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
    );
  }
}
