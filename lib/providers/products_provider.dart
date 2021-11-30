import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_excpection.dart';

import 'Products.dart';

class ProductsProvider with ChangeNotifier {
  final String authToken;
  final String userId;
  ProductsProvider(this.userId, this.authToken, this._items);
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return items.where((pro) => pro.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts([bool filterProduct = false]) async {
    String filter =
        !filterProduct ? '' : 'orderBy="createrId"&equalTo="$userId"';
    var url = Uri.parse('https://shopping-app-a5b8b-default-rtdb.firebaseio.com'
        '/products.json?auth=$authToken&$filter');

    print('trying to fetch products...');

    try {
      final response = await http.get(url);
      Map<String, dynamic> extractedData = json.decode(response.body);

      if (extractedData == null) return;

      print('trying to fetch favorite statuse now ...');

      url = Uri.parse('https://shopping-app-a5b8b-default-rtdb.firebaseio.com'
          '/userFavorites/$userId.json?auth=$authToken');

      final isFavResponse = await http.get(url);
      final responseDate = json.decode(isFavResponse.body);

      print('done fetching : $responseDate');

      List<Product> loadedProducts = [];
      extractedData.forEach(
        (productId, value) {
          loadedProducts.add(
            Product(
              description: value['description'],
              id: productId,
              imageUrl: value['imageUrl'],
              price: value['price'],
              title: value['title'],
              //double ?? means if it is null it takse the value after the ??
              isFavorite: responseDate == null
                  ? false
                  : responseDate[productId] ?? false,
            ),
          );
        },
      );
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print('oops error while addingList ${error.toString()}');
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shopping-app-a5b8b-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'imageUrl': product.imageUrl,
            'description': product.description,
            'price': product.price,
            'createrId': userId,
          },
        ),
      );
      Product newProduct = Product(
        description: product.description,
        id: json.decode(response.body)['name'],
        imageUrl: product.imageUrl,
        price: product.price,
        title: product.title,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> removeProduct(String id) async {
    print('this is the id in removeProduct + $id');

    final url = Uri.parse(
        'https://shopping-app-a5b8b-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');

    final _itemIndex = _items.indexWhere((product) => product.id == id);
    var _removedProduct = _items[_itemIndex];
    _items.removeWhere((product) => product.id == id);
    notifyListeners();

    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw HttpException(
            'http request failed could not delete the product in \' productProvider-removeProduct\'');
      }
      _removedProduct = null;
    } catch (error) {
      _items.insert(_itemIndex, _removedProduct);
      notifyListeners();
    }
  }

  Future<void> updateProduct(String id, Product produtc) async {
    int index = _items.indexWhere((product) => product.id == id);
    if (index >= 0) {
      final url = Uri.parse(
          'https://shopping-app-a5b8b-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      try {
        await http.patch(
          url,
          body: json.encode({
            'title': produtc.title,
            'imageUrl': produtc.imageUrl,
            'description': produtc.description,
            'price': produtc.price,
          }),
        );
      } catch (error) {
        print('found error during patching \' $error \'');
        throw (error);
      }
      _items[index] = produtc;
      notifyListeners();
    } else
      print('no exsiting product found ');
  }

  List<Product> get favoriteProducts {
    List<Product> favoriteItems =
        items.where((product) => product.isFavorite).toList();
    return favoriteItems;
  }

  Product findById(String id) {
    Product wantedProduct =
        _items.firstWhere((product) => product.id == id, orElse: () => null);

    return wantedProduct;
  }
}
