import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:terra_fertil/exception/http_exception.dart';
import 'package:terra_fertil/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:terra_fertil/utils/constants.dart';

class ProductList with ChangeNotifier {
  List<Product> _items = [];
  final String? _token;
  final String? _userId;

  List<Product> get items => [..._items];

  List<Product> get favoriteItems =>
      _items.where((prod) => prod.isFavorite).toList();

  ProductList([this._token = '', this._items = const [], this._userId = '']);

  Future<void> loadProducts() async {
    _items.clear();
    final response = await http.get(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token'),
    );
    if (response.body == 'null') return;
    final favResponse = await http.get(
      Uri.parse('${Constants.USER_FAVORITE_URL}/$_userId.json?auth=$_token'),
    );
    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((prductId, productData) {
      final favorite = (favData[prductId]?['isFavorite'] as bool?) ?? false;
      _items.add(
        Product(
          id: prductId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          isFavorite: favorite,
          imageUrl: productData['imageUrl'],
        ),
      );
    });
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token'),
      body: jsonEncode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
      }),
    );
    final id = jsonDecode(response.body)['name'];
    _items.add(
      Product(
        id: id,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
          '${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token',
        ),
        body: jsonEncode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _items.remove(product);
      notifyListeners();

      final reponse = await http.delete(
        Uri.parse(
          '${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token',
        ),
      );

      if (reponse.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpExceptionn(
          msg: 'Não foi posível excluir o produto!',
          statusCode: reponse.statusCode,
        );
      }
    }
  }

  Future<void> saveProductFromData(Map<String, Object> data) {
    bool hasId = data['id'] != null;
    final newProduct = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      title: data['title'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(newProduct);
    } else {
      return addProduct(newProduct);
    }
  }
}
