import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/orders_page.dart';
import '../pages/user_products_page.dart';
import '../providers/auth_provider.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      child: Column(
        children: [
          AppBar(
            title: Center(child: Text('Somthing !')),
            automaticallyImplyLeading: false,
          ),
          // Container(
          //   height: 120,
          //   color: Theme.of(context).primaryColor,
          //   padding: EdgeInsets.all(20),
          //   alignment: Alignment.bottomCenter,
          //   child: Text(
          //     'Somthing !',
          //     style: TextStyle(
          //       fontSize: 26,
          //       fontWeight: FontWeight.bold,
          //     ),
          //     softWrap: true,
          //     overflow: TextOverflow.fade,
          //   ),
          // ),
          Divider(height: 10),
          SizedBox(
            height: 10,
          ),
          _buildListTile(context, Icons.shop, 'Products',
              'find new items you might like ', '/'),
          Divider(
            height: 5,
          ),
          _buildListTile(context, Icons.payment, 'Orders',
              'see all your orders status...', OrdersPage.routeName),
          Divider(
            height: 5,
          ),
          _buildListTile(context, Icons.edit, 'Manage products',
              'see all your products here', UserProductsPage.routeName),
          Divider(
            height: 5,
          ),
          Padding(
            padding: EdgeInsets.all(1),
            child: ListTile(
              leading: Icon(
                Icons.exit_to_app_rounded,
                color: Colors.grey,
                size: 40,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');

                Provider.of<Auth>(context, listen: false).logOut();
              },
            ),
          ),
          Divider(
            height: 5,
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title,
      String subtitle, String routeName) {
    return Padding(
      padding: EdgeInsets.all(1),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.grey,
          size: 40,
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.grey),
        ),
        subtitle: Text(subtitle),
        onTap: () => Navigator.of(context).pushReplacementNamed(routeName),
      ),
    );
  }
}
