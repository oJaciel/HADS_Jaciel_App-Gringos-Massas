import 'package:app_gringos_massas/components/common/date_divider.dart';
import 'package:app_gringos_massas/components/stock/stock_transaction_item.dart';
import 'package:app_gringos_massas/providers/stock_provider.dart';
import 'package:app_gringos_massas/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StockTransactionPage extends StatelessWidget {
  const StockTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stockProvider = Provider.of<StockProvider>(context);
    final stockTransactions = stockProvider.transactions;

    return Scaffold(
      appBar: AppBar(title: Text('Transações de Estoque')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SafeArea(
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
                'Histórico de Transações',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              stockTransactions.isNotEmpty
                  ? Flexible(
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: stockTransactions.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DateDivider(
                                index: index,
                                list: stockTransactions,
                              ),
                              StockTransactionItem(stockTransactions[index]),
                            ],
                          );
                        },
                      ),
                    )
                  : Expanded(
                    child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Nenhuma transação encontrada',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            SizedBox(height: 16),
                            Icon(Icons.error_outline_rounded, size: 24),
                            SizedBox(height: 16),
                            Text('Adicione uma nova transação para visualizar!'),
                          ],
                        ),
                      ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
