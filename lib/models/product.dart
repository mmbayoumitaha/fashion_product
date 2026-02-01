class Product {
  final int id;
  final String name;
  final double price;
  final String image;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': id,
      'name': name,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }

  Map<String, dynamic> toFavoriteMap() {
    return {'productId': id, 'name': name, 'price': price, 'image': image};
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['productId'] as int,
      name: map['name'] as String,
      price: (map['price'] as num).toDouble(),
      image: map['image'] as String,
      quantity: (map['quantity'] as int?) ?? 1,
    );
  }
}
