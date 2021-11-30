import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';

import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';
import './edit_product_page.dart';

class UserProductsPage extends StatelessWidget {
  static const String routeName = '/user-products-page';

  Future<void> _refreshPage(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsProv = Provider.of<ProductsProvider>(context, listen: true);
    print('widget rebuilt');
    return Scaffold(
      appBar: AppBar(
        title: const Text('your products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _editeProduct(context);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _refreshPage(context),
        builder: (ctx, snapShot) => RefreshIndicator(
          onRefresh: () => _refreshPage(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: snapShot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : Consumer<ProductsProvider>(
                    builder: (ctx, productProv, _) => ListView.builder(
                      itemCount: productProv.items.length,
                      itemBuilder: (ctx, index) => UserProductItem(
                        productProv.items[index].id,
                        productProv.items[index].title,
                        productProv.items[index].imageUrl,
                      ),
                    ),
                  ),
          ),
        ),
      ),
      drawer: MainDrawer(),
    );
  }

  _editeProduct(BuildContext context) {
    Navigator.of(context).pushNamed(EditProductPage.routeName);
  }
}
