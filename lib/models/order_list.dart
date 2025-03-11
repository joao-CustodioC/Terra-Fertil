import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:terra_fertil/models/cart.dart';
import 'package:terra_fertil/models/order.dart';

class OrderList with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items => [..._items];

  int get itemsCount =>
      _items.length;

  void addOrder(Cart cart) {
    _items.insert(
        0,
        Order(
            id: Random().nextDouble().toString(),
            date: DateTime.now(),
            total: cart.totalAmount,
            products: cart.items.values.toList()
        )
    );
    notifyListeners();
  }
}