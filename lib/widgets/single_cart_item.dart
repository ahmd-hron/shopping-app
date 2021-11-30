import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

import '../models/cart.dart';

class SingleCartItem extends StatelessWidget {
  final CartItem cartItem;
  final String productId;
  const SingleCartItem(this.cartItem, this.productId);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (_) {
        return showDialog<bool>(
          barrierDismissible: true,
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('are you sure?'),
            content: Text(
              'do  you want to remove  \'${cartItem.title}\' from your cart ?',
            ),
            elevation: 4,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(
                    true,
                  );
                },
                child: Text(
                  'Yes',
                  textAlign: TextAlign.end,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text(
                  'NO',
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        );
      },
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
      ),
      onDismissed: (_) {
        Provider.of<CartProvider>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: FittedBox(
                  child: Text(
                    '\$${cartItem.price}',
                  ),
                ),
              ),
            ),
            trailing: Text(
              'x${cartItem.quanity}',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            title: Text(cartItem.title),
            subtitle: Text((cartItem.price * cartItem.quanity).toString()),
          ),
        ),
      ),
    );
  }
}
