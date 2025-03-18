import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/constants.dart';

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

  Future<void> toggleFavorite(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final url = Uri.parse(
        '${Constants.USER_FAVORITE_URL}/$userId/$id.json?auth=$token',
      );
      final response = await http.put(
        url,
        body: jsonEncode({'isFavorite': isFavorite}),
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
