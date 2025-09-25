class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final int stockQuantity;
  final bool isActive;
  final bool hasMovement;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.stockQuantity = 0,
    this.isActive = true,
    this.hasMovement = false,
  });
}
