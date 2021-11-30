import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String title;
  final String description;
  final String id;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.description,
    @required this.id,
    @required this.imageUrl,
    this.isFavorite = false,
    @required this.price,
    @required this.title,
  });

  Future<void> toggleFavorite(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    Uri url = Uri.parse(
        'https://shopping-app-a5b8b-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token');
    try {
      final resopnse = await http.put(url, body: json.encode(isFavorite));
      if (resopnse.statusCode >= 400) {
        throw HttpException(
            'couldn\'t add this to favorite please check your internet connection');
      }
    } catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
