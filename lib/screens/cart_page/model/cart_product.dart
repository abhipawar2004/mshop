class CartProduct {
  final String id;
  final String name;
  final String size;
  final double originalPrice;
  final double currentPrice;
  int quantity;
  final String imageUrl;

  CartProduct({
    required this.id,
    required this.name,
    required this.size,
    required this.originalPrice,
    required this.currentPrice,
    required this.quantity,
    required this.imageUrl,
  });
}

