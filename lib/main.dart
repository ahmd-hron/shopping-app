import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './pages/orders_page.dart';
import 'pages/products_overview_page.dart';
import './pages/product_details_page.dart';
import './providers/products_provider.dart';
import './providers/cart_provider.dart';
import './pages/cart_page.dart';
import './pages/user_products_page.dart';
import './pages/edit_product_page.dart';
import './pages/4.1 auth_screen.dart';
import './providers/auth_provider.dart';
import './pages/16.2 splash_screen.dart';

import './providers/order_providers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          update: (ctx, auth, preivousProductProvider) => ProductsProvider(
              auth.userId,
              auth.token,
              preivousProductProvider == null
                  ? []
                  : preivousProductProvider.items),
          create: null,
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProxyProvider<Auth, OrderProvider>(
          create: null,
          update: (ctx, authProvider, privousOrders) => OrderProvider(
              authProvider.userId,
              authProvider.token,
              privousOrders == null ? [] : privousOrders.myOrders),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'MyShopApp',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'lato',
          ),
          home: auth.isAuth
              ? ProductsOverViewPage()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResoultSnapShot) =>
                      authResoultSnapShot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            // ProductsOverViewPage.routeName: (ctx) => ProductsOverViewPage(),
            ProductDetailsPage.routeName: (ctx) => ProductDetailsPage(),
            CartPage.routeNam: (ctx) => CartPage(),
            OrdersPage.routeName: (ctx) => OrdersPage(),
            UserProductsPage.routeName: (ctx) => UserProductsPage(),
            EditProductPage.routeName: (ctx) => EditProductPage(),
          },
        ),
      ),
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   @override
//   build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('ShopsApp'),
//       ),
//       body: Center(
//         child: Text('let\'s build a shop application '),
//       ),
//     );
//   }
// }
