import 'package:app_gringos_massas/components/dialogs/delete_alert_dialog.dart';
import 'package:app_gringos_massas/components/common/product_image.dart';
import 'package:app_gringos_massas/models/product.dart';
import 'package:app_gringos_massas/providers/product_provider.dart';
import 'package:app_gringos_massas/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductPageItem extends StatelessWidget {
  const ProductPageItem(this.product, {super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ProductImage(product: product, height: 90, width: 80),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text('Valor: R\$ ${product.price.toStringAsFixed(2)}'),
                SizedBox(height: 4),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: product.isActive ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 10,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.circle, size: 6, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              product.isActive ? 'Ativo' : 'Inativo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),

            IconButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pushNamed(AppRoutes.PRODUCT_FORM, arguments: product);
              },
              icon: Icon(Icons.edit_rounded, color: Colors.grey[700]),
              iconSize: 30,
            ),
            if (product.hasMovement == false)
              IconButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => DeleteAlertDialog(
                    title: 'Deseja excluir o produto?',
                    content: 'Excluir Produto',
                    deleteMethod: () => Provider.of<ProductProvider>(
                      context,
                      listen: false,
                    ).removeProduct(product),
                  ),
                ),
                icon: Icon(Icons.delete_rounded, color: Colors.red),
                iconSize: 30,
              ),
          ],
        ),
      ),
    );
  }
}
