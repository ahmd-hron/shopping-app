import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopping_app/widgets/main_drawer.dart';

import '../widgets/single_cart_item.dart';

import '../providers/cart_provider.dart';
import '../providers/order_providers.dart';

class CartPage extends StatefulWidget {
  static const routeNam = '/cart-page';

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    var scaffoldMessanger = ScaffoldMessenger.of(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  _isloading
                      ? Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircularProgressIndicator(),
                        )
                      : TextButton(
                          onPressed: () async {
                            if (cartProvider.items.values.toList().isEmpty) {
                              await showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        title: Text('your cart is empty'),
                                        content: Text('add Items to Cart?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushReplacementNamed('/');
                                            },
                                            child: Text('YES!'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('not now!'),
                                          ),
                                        ],
                                      ));
                              return;
                            }
                            try {
                              setState(() {
                                _isloading = true;
                              });
                              await Provider.of<OrderProvider>(context,
                                      listen: false)
                                  .addOrder(
                                cartProvider.items.values.toList(),
                                cartProvider.totalAmount,
                              );
                              setState(() {
                                _isloading = false;
                              });
                              cartProvider.clearCart();
                              scaffoldMessanger.hideCurrentSnackBar();
                              scaffoldMessanger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'item added to your oreders succsusfully',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            } catch (error) {
                              await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('couldn\'t finish adding order'),
                                  content: Text(
                                      'please check your internet connection and try again'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Ok'),
                                    )
                                  ],
                                ),
                              );
                              setState(() {
                                _isloading = false;
                              });
                            }
                          },
                          child: Text(
                            'order Now !',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (ctx, index) => SingleCartItem(
                  cartItems.values.toList()[index],
                  cartItems.keys.toList()[index]),
            ),
          ),
        ],
      ),
    );
  }
}
