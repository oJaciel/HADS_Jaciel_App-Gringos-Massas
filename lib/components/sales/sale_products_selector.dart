import 'package:app_gringos_massas/components/common/product_image.dart';
import 'package:app_gringos_massas/components/sales/sale_form_item.dart';
import 'package:app_gringos_massas/models/product.dart';
import 'package:app_gringos_massas/models/sale.dart';
import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:app_gringos_massas/providers/sale_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleProductsSelector extends StatelessWidget {
  final bool isEdit;
  final Sale? existingSale;

  const SaleProductsSelector({
    super.key,
    required this.isEdit,
    this.existingSale,
  });

  @override
  Widget build(BuildContext context) {
    final products = context.read<ProductProvider>().activeProducts;

    return Column(
      children: [
        if (isEdit)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Produtos não podem ser editados!')],
          ),
        Opacity(
          opacity: isEdit ? 0.4 : 1,
          child: AbsorbPointer(
            absorbing: isEdit,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Produtos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Dropdown para adicionar produto
                DropdownButtonFormField<Product>(
                  decoration: const InputDecoration(
                    labelText: 'Adicionar produto',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  items: products.map((product) {
                    return DropdownMenuItem<Product>(
                      value: product,
                      child: Row(
                        children: [
                          ProductImage(product: product, height: 36, width: 36),
                          const SizedBox(width: 10),
                          Text(product.name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      context.read<SaleItemProvider>().addItem(value);
                    }
                  },
                ),
                const SizedBox(height: 12),

                // Lista de produtos adicionados
                Consumer<SaleItemProvider>(
                  builder: (context, saleItems, _) {
                    final itemsList = isEdit
                        ? existingSale?.products ?? []
                        : saleItems.items.values.toList();

                    if (itemsList.isEmpty) {
                      return SizedBox(
                        height: 120,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.shopping_cart_outlined,
                                size: 40,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Nenhum produto adicionado',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itemsList.length,
                      itemBuilder: (ctx, i) => SaleFormItem(itemsList[i]),
                    );
                  },
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
