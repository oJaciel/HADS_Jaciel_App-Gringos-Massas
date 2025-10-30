import 'package:app_gringos_massas/pages/reports/sale_reports_page.dart';
import 'package:app_gringos_massas/pages/reports/stock_reports_page.dart';
import 'package:flutter/material.dart';

class ReportsOverviewPage extends StatefulWidget {
  const ReportsOverviewPage({super.key, this.initShowStock = false});

  final bool initShowStock;

  @override
  State<ReportsOverviewPage> createState() => _ReportsOverviewPageState();
}

class _ReportsOverviewPageState extends State<ReportsOverviewPage> {
  late int _selectedIndex;

  final List<Widget> _pages = const [SaleReportsPage(), StockReportsPage()];

  @override
  void initState() {
    super.initState();
    // Define o índice inicial
    if (widget.initShowStock) {
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
      appBar: AppBar(title: Text(_selectedIndex == 0 ? 'Relatórios de Vendas' : 'Relatórios de Estoque'),),
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: theme.primaryColor,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Vendas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_rounded),
            label: 'Estoque',
          ),
        ],
      ),
    );
  }
}
