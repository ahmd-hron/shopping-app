import 'package:flutter/foundation.dart';

import '../models/cart.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get items {
    return {..._cartItems};
  }

  int get itemsCount {
    return _cartItems.length;
  }

  double get totalAmount {
    double total = 0.0;
    _cartItems.forEach((productId, cartItem) {
      for (var i = 0; i < cartItem.quanity; i++) {
        total += cartItem.price * cartItem.quanity;
      }
    });
    return total;
  }

  void addCartItem(String productId, double price, String title) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
        productId,
        (existing) => CartItem(
          id: existing.id,
          price: existing.price,
          quanity: existing.quanity + 1,
          title: existing.title,
        ),
      );
    } else {
      CartItem newItem = CartItem(
        id: DateTime.now().toString(),
        title: title,
        quanity: 1,
        price: price,
      );
      _cartItems.putIfAbsent(productId, () => newItem);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void removeQuantity(String productId) {
    if (!_cartItems.containsKey(productId)) return;
    if (_cartItems[productId].quanity == 1) {
      removeItem(productId);
      return;
    }
    _cartItems.update(productId, (oldVallue) {
      CartItem item = CartItem(
        id: oldVallue.id,
        title: oldVallue.title,
        quanity: oldVallue.quanity - 1,
        price: oldVallue.price,
      );
      return item;
    });
  }

  void clearCart() {
    _cartItems = {};
    notifyListeners();
  }
}
