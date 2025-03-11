import 'package:terra_fertil/models/cart_item.dart';

class Order {
  final String id;
  final DateTime date;
  final List<CartItem> products;
  final double total;

  Order({
    required this.id,
    required this.date,
    required this.total,
    required this.products,
  });
}
