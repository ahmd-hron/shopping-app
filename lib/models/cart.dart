import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quanity;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quanity,
    @required this.price,
  });
}
