import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app/models/cart.dart';

// import '../pages/orders_page.dart';
// import '../models/cart.dart';
import '../models/orders.dart' as order;

class OrderItem extends StatefulWidget {
  final order.OrderItem myOrder;

  OrderItem(this.myOrder);
  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem>
    with SingleTickerProviderStateMixin {
  bool expanded = false;

  AnimationController _controller;
  Animation _slidedAnimation;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(microseconds: 300));
    _slidedAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -0.1)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceInOut),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slidedAnimation,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.myOrder.total}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy       hh:mm')
                    .format(widget.myOrder.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(!expanded ? Icons.expand_more : Icons.expand_less),
                onPressed: () {
                  setState(() {
                    expanded = !expanded;
                  });
                  if (expanded)
                    _controller.forward();
                  else
                    _controller.reverse();
                },
              ),
            ),
            // if (expanded)
            AnimatedContainer(
              constraints: BoxConstraints(
                minHeight: expanded
                    ? min(widget.myOrder.items.length * 20.0 + 100, 120)
                    : 0,
                maxHeight: expanded
                    ? min(widget.myOrder.items.length * 20.0 + 100, 120)
                    : 0,
              ),
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 300),
              // height: min(widget.myOrder.items.length * 20.0 + 100, 120),
              child: ListView(
                children: widget.myOrder.items
                    .map((product) => _buildListViewItem(product))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListViewItem(CartItem product) {
    return Column(children: [
      ListTile(
        title: Text(
          product.title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          '\$${product.price}   x   ${product.quanity}',
          style: TextStyle(fontSize: 15, color: Colors.grey[800]),
        ),
      ),
      Divider()
    ]);
  }
}
