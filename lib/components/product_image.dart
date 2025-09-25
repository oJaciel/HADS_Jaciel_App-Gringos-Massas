import 'package:app_gringos_massas/models/product.dart';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({super.key,  required this.product, required this.height, required this.width});

  final Product product;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      height: height,
      width: width,
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
    );
  }
}
