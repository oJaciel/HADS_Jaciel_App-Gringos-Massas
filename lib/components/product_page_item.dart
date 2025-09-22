import 'package:app_gringos_massas/models/product.dart';
import 'package:flutter/material.dart';

class ProductPageItem extends StatelessWidget {
  const ProductPageItem(this.product, {super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(2),
      child: GestureDetector(
        onTap: () {
          print('Clicou');
        },
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(product.name, textAlign: TextAlign.start),
            trailing: Text(
              'R\$ ${product.price}',
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.white),
            ),
          ),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (ctx, error, stack) => Container(
              color: Colors.grey,
              child: Center(
                child: Icon(
                  Icons.no_photography_rounded,
                  size: 50,
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
