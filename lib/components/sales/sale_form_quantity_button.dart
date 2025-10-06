import 'package:app_gringos_massas/models/sale_item.dart';
import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:app_gringos_massas/providers/sale_item_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleFormQuantityButton extends StatelessWidget {
  const SaleFormQuantityButton(this.item, {super.key});

  final SaleItem item;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SaleItemProvider>(context);
    final product = Provider.of<ProductProvider>(
      context,
      listen: false,
    ).getProductById(item.productId);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Botão de remover
          InkWell(
            onTap: () => provider.removeSingleItem(item.productId),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  bottomLeft: Radius.circular(6),
                ),
              ),
              child: const Icon(Icons.remove_rounded, size: 16),
            ),
          ),

          // Quantidade
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            color: Colors.transparent,
            child: Text(
              item.quantity.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),

          // Botão de adicionar
          InkWell(
            onTap: () => provider.addItem(product),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
              ),
              child: const Icon(Icons.add, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
