import '../models/product.dart';

class AppConstants {

  AppConstants._();

  static final  List<Product> products = [
    Product(
      id: 1,
      name: 'Green Sweater',
      price: 72.59,
      image: 'assets/images/product_1.png',
    ),
    Product(
      id: 2,
      name: 'Denim Jacket',
      price: 85.00,
      image: 'assets/images/product_2.png',
    ),
    Product(
      id: 3,
      name: 'Leather Jacket',
      price: 120.00,
      image: 'assets/images/product_3.png',
    ),
    Product(
      id: 4,
      name: 'Elegant Blouse',
      price: 65.50,
      image: 'assets/images/product_4.png',
    ),
  ];
}