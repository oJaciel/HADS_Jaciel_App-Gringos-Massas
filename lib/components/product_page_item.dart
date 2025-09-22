import 'package:app_gringos_massas/models/product.dart';
import 'package:flutter/material.dart';

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
              child: Image.network(
                height: 70,
                width: 60,
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, stack) => Container(
                  height: 70,
                  width: 60,
                  color: Colors.grey,
                  child: Icon(
                    Icons.no_photography_rounded,
                    size: 30,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${product.name}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text('R\$ ${product.price.toStringAsFixed(2)}'),
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
              onPressed: () {},
              icon: Icon(Icons.edit_rounded, color: Colors.grey[700]),
              iconSize: 30,
            ),
            //if (produto já tem venda, não pode excluir)
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete_rounded, color: Colors.red),
              iconSize: 30,
            ),
          ],
        ),
      ),
    );
  }
}
