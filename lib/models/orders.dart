import 'package:flutter/foundation.dart';
import 'cart.dart';

class OrderItem {
  String id;
  DateTime dateTime;
  double total;
  List<CartItem> items;

  OrderItem({
    @required this.id,
    @required this.dateTime,
    @required this.total,
    @required this.items,
  });
}
