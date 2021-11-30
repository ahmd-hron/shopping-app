import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class ProductDetailsPage extends StatelessWidget {
  static const String routeName = '/Product-Detail-page';

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context).settings.arguments;
    final selectedProduct =
        Provider.of<ProductsProvider>(context, listen: false).findById(id);

    return Scaffold(
      // appBar: AppBar(
      // title: Text(selectedProduct.title),
      // ),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 300,
          //the appbar won't scroll out of view becuase of pinned
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(selectedProduct.title),
            background: Hero(
              tag: id,
              child: Image.network(
                selectedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(
              height: 10,
            ),
            Text(
              'price \$${selectedProduct.price}',
              style: TextStyle(fontSize: 25, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              selectedProduct.description,
              style: TextStyle(
                fontSize: 23,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            )
          ]),
        )
      ]),
    );
  }
}
