import 'package:app_gringos_massas/pages/stock/stock_balance_page.dart';
import 'package:app_gringos_massas/pages/stock/stock_transaction_page.dart';
import 'package:flutter/material.dart';

class StockOverviewPage extends StatefulWidget {
  const StockOverviewPage({super.key, this.initShowBalance = false});

  final bool initShowBalance;

  @override
  State<StockOverviewPage> createState() => _ReportsOverviewPageState();
}

class _ReportsOverviewPageState extends State<StockOverviewPage> {
  late int _selectedIndex;

  final List<Widget> _pages = const [StockTransactionPage(), StockBalancePage()];

    @override
  void initState() {
    super.initState();
    // Define o índice inicial com base nas flags recebidas pelo widget
    if (widget.initShowBalance) {
      _selectedIndex = 1;
    } else {
      _selectedIndex = 0;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(_selectedIndex == 0 ? 'Transações de Estoque' : 'Saldos em Estoque'),),
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: theme.primaryColor,
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.scaffoldBackgroundColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_vert_rounded),
            label: 'Transações',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_rounded),
            label: 'Saldos',
          ),
        ],
      ),
    );
  }
}
