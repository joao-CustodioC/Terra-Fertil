import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:terra_fertil/models/cart.dart';
import 'package:terra_fertil/models/cart_item.dart';
import 'package:terra_fertil/models/order.dart';
import '../utils/constants.dart';
import 'package:http/http.dart' as http;

class OrderList with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items => [..._items];

  int get itemsCount => _items.length;

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
      Uri.parse('${Constants.ORDER_BASE_URL}.json'),
      body: jsonEncode({
        'total': cart.totalAmount,
        'date': date.toIso8601String(),
        'products':
        cart.items.values
            .map(
              (cart) =>
          {
            'id': cart.id,
            'productId': cart.productId,
            'title': cart.title,
            'quantity': cart.quantity,
            'price': cart.price,
          },
        )
            .toList(),
      }),
    );
    final id = jsonDecode(response.body)['name'];
    _items.insert(
      0,
      Order(
        id: id,
        date: date,
        total: cart.totalAmount,
        products: cart.items.values.toList(),
      ),
    );
    notifyListeners();
  }

  Future<void> loadOrder() async {
    _items.clear();
    final response = await http.get(
      Uri.parse('${Constants.ORDER_BASE_URL}.json'),
    );
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((orderId, orderData) {
      _items.add(
        Order(
          id: orderId,
          date: DateTime.parse(orderData['date']),
          total: orderData['total'],
          products: (orderData['products'] as List<dynamic>).map((i) {
            return CartItem(
              id: i['id'],
              productId: i['productId'],
              title: i['title'],
              quantity: i['quantity'],
              price: i['price']
            );
          }).toList(),
        ),
      );
    });
    notifyListeners();
  }
}
