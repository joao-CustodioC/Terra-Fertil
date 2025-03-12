import 'dart:math';
import 'package:flutter/material.dart';
import 'package:terra_fertil/models/cart_item.dart';
import 'package:terra_fertil/models/product.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }
  void removeLastItem(String productId) {

    if(!_items.containsKey(productId)){
      return;
    }
    if(_items[productId]?.quantity == 1) {
      _items.remove(productId);
    } else {
      _items.update(
        productId,
            (value) =>
            CartItem(
              id: value.id,
              productId: value.productId,
              title: value.title,
              quantity: value.quantity - 1,
              price: value.price,
            ),
      );
    }
    notifyListeners();
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
            (value) =>
            CartItem(
              id: value.id,
              productId: value.productId,
              title: value.title,
              quantity: value.quantity + 1,
              price: value.price,
            ),
      );
    } else {
      _items.putIfAbsent(product.id,
            () =>
            CartItem(
              id: Random().nextDouble().toString(),
              productId: product.id,
              title: product.title,
              quantity: 1,
              price: product.price,
            ),
      );
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
