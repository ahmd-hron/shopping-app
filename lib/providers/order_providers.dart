import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_excpection.dart';

import '../models/cart.dart';
import '../models/orders.dart';

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;
  OrderProvider(this.userId, this.authToken, this._orders);

  List<OrderItem> get myOrders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartItems, double totalPrice) async {
    final url = Uri.parse(
        'https://shopping-app-a5b8b-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timeStamp = DateTime.now();

    try {
      final respons = await http.post(
        url,
        body: json.encode(
          {
            'totalPrice': totalPrice,
            'dateTime': timeStamp.toIso8601String(),
            'products': cartItems
                .map(
                  (item) => {
                    'id': item.id,
                    'price': item.price,
                    'quanity': item.quanity,
                    'title': item.title
                  },
                )
                .toList(),
          },
        ),
      );
      if (respons.statusCode >= 400) {
        throw HttpException('couldn\'t finish ordering ');
      }
      // OrderItem myOrder = OrderItem(
      //     id: json.decode(respons.body)['name'],
      //     dateTime: timeStamp,
      //     total: totalPrice,
      //     items: cartItems);

      // _orders.insert(0, myOrder);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndGetOrders() async {
    final url = Uri.parse(
        'https://shopping-app-a5b8b-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    List<OrderItem> extractedOrders = [];
    try {
      final respone = await http.get(url);
      final extractedValues = json.decode(respone.body) as Map<String, dynamic>;

      if (extractedValues == null) {
        return;
      }
      extractedValues.forEach((orederId, order) {
        List<CartItem> tempItems = [];
        for (var i = 0; i < order['products'].length; i++) {
          CartItem item = CartItem(
            id: order['products'][i]['id'],
            title: order['products'][i]['title'],
            quanity: order['products'][i]['quanity'],
            price: order['products'][i]['price'],
          );

          tempItems.add(item);
        }
        DateTime time = DateTime.parse(order['dateTime']);
        double totalPrice = order['totalPrice'];
        OrderItem orderItem = OrderItem(
          dateTime: time,
          total: totalPrice,
          id: orederId,
          items: tempItems,
        );
        extractedOrders.insert(0, orderItem);
      });
      _orders = extractedOrders;
    } catch (error) {
      throw HttpException('order fetch failed');
    }
  }
}
