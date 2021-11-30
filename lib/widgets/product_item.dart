import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/auth_provider.dart';

import '../providers/cart_provider.dart';
// import '../providers/products_provider.dart';

import '../providers/Products.dart';

import '../pages/product_details_page.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product = Provider.of<Product>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final authProvider = Provider.of<Auth>(context, listen: false);
// consumer alwys lister to changes AKA listen = true ;

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            icon: Consumer<Product>(
              builder: (ctx, product, child) => Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
            ),
            onPressed: () {
              product.toggleFavorite(authProvider.token, authProvider.userId);
            },
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              cartProvider.addCartItem(
                product.id,
                product.price,
                product.title,
              );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  // width: 10,
                  // padding: EdgeInsets.all(30),
                  // margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  duration: Duration(milliseconds: 2000),
                  elevation: 5,
                  content: Text(
                    'you just added ${product.title} to the cart',
                  ),
                  action: SnackBarAction(
                    onPressed: () {
                      cartProvider.removeQuantity(product.id);
                    },
                    label: 'UNDO',
                  ),
                ),
              );
            },
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailsPage.routeName,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              fadeInCurve: Curves.bounceIn,
              fit: BoxFit.cover,
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(
                product.imageUrl,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
