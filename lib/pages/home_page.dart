import 'package:app_gringos_massas/components/common/app_drawer.dart';
import 'package:app_gringos_massas/components/common/home_page_button.dart';
import 'package:app_gringos_massas/providers/general_provider.dart';
import 'package:app_gringos_massas/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    await Provider.of<GeneralProvider>(
      context,
      listen: false,
    ).loadDatabase(context);

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gringo\'s Massas')),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<GeneralProvider>(
          context,
          listen: false,
        ).loadDatabase(context),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: MediaQuery.sizeOf(context).width * 0.5,
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),

                      children: [
                        HomePageButton(
                          title: 'Produtos',
                          icon: Icons.sell_rounded,
                          onTap: () => Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.PRODUCTS),
                        ),
                        HomePageButton(
                          title: 'Estoque',
                          icon: Icons.inventory_2_rounded,
                          onTap: () => Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.STOCK_OVERVIEW),
                        ),
                        HomePageButton(
                          title: 'Vendas',
                          icon: Icons.shopping_cart_rounded,
                          onTap: () =>
                              Navigator.of(context).pushNamed(AppRoutes.SALES),
                        ),
                        HomePageButton(
                          title: 'Relatórios',
                          icon: Icons.analytics_rounded,
                          onTap: () => Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.REPORTS_OVERVIEW),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
