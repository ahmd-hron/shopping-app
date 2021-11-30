import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products_provider.dart';

import '../providers/cart_provider.dart';
import '../pages/cart_page.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/main_drawer.dart';
import '../helper/costum_route.dart';

enum popMenuOptions { favorites, all }

class ProductsOverViewPage extends StatefulWidget {
  static const routeName = '/ProductPageOverView';

  @override
  _ProductsOverViewPageState createState() => _ProductsOverViewPageState();
}

class _ProductsOverViewPageState extends State<ProductsOverViewPage> {
  bool _showFavoriteOnly = false;
  bool _isLoading = false;
  bool _isInit = true;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((value) =>
    //     Provider.of<ProductsProvider>(context, listen: false)
    //         .fetchAndSetProducts());
    super.initState();
  }

  //this method runs after state have been instinlized fully but before first build runs
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context, listen: false)
          .fetchAndSetProducts()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('favorites'),
                value: popMenuOptions.favorites,
              ),
              PopupMenuItem(
                child: Text('all'),
                value: popMenuOptions.all,
              ),
            ],
            child: Icon(
              Icons.more_vert,
            ),
            onSelected: (popMenuOptions value) {
              setState(() {
                if (value == popMenuOptions.favorites) {
                  _showFavoriteOnly = true;
                } else if (value == popMenuOptions.all) {
                  _showFavoriteOnly = false;
                }
              });
            },
          ),
          Consumer<CartProvider>(
            builder: (ctx, cart, child) => Badge(
              child: child,
              value: cart.itemsCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushReplacement(CustomeRoute(
                  builder: (ctx) => CartPage(),
                ));
              },
            ),
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(_showFavoriteOnly),
      drawer: MainDrawer(),
    );
  }
}
