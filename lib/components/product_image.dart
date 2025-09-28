import 'package:app_gringos_massas/models/product.dart';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.product,
    this.height = 30,
    this.width = 30,
  });

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
        height: height,
        width: width,
        color: Colors.grey,
        child: Icon(
          Icons.no_photography_rounded,
          size: height / 2,
          color: Colors.grey[800],
        ),
      ),
    );
  }
}
