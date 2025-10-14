import 'package:app_gringos_massas/components/common/product_image.dart';
import 'package:app_gringos_massas/components/sales/sale_form_quantity_button.dart';
import 'package:app_gringos_massas/models/sale_item.dart';
import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:app_gringos_massas/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleFormItem extends StatelessWidget {
  const SaleFormItem(this.item, {super.key});

  final SaleItem item;

  @override
  Widget build(BuildContext context) {
    final itemTotal = item.unitPrice * item.quantity;
    final product = Provider.of<ProductProvider>(
      context,
      listen: false,
    ).getProductById(item.productId);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ProductImage(product: product, height: 40, width: 40),
        ),
        title: Text(item.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        '${AppUtils.formatPrice(item.unitPrice)} x ${item.quantity} = ',
                  ),
                  TextSpan(
                    text: AppUtils.formatPrice(itemTotal),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Em estoque: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(product.stockQuantity.toString()),
              ],
            ),
          ],
        ),
        trailing: SaleFormQuantityButton(item),
      ),
    );
  }
}
