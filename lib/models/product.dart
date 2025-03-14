import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final url = Uri.parse(
          'https://terra-fertil-dc760-default-rtdb.firebaseio.com/products/$id.json');
      final response = await http.patch(
        url,
        body: jsonEncode({
          'isFavorite': isFavorite,
        }),
      );

      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
        throw Exception('Erro ao favoritar o produto');
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
      throw error;
    }
  }
}
