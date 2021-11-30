import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../models/orders.dart';
import '../providers/order_providers.dart';
import '../widgets/order_item.dart';
import '../widgets/main_drawer.dart';

class OrdersPage extends StatefulWidget {
  static const String routeName = '/orders-page';

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool initStat = true;
  bool _isLoaded = true;

  @override
  void didChangeDependencies() {
    if (initStat) {
      setState(() {
        _isLoaded = false;
      });
      Provider.of<OrderProvider>(context, listen: false)
          .fetchAndGetOrders()
          .then((_) {
        setState(() {
          _isLoaded = true;
        });
      });
    }
    initStat = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('your orders'),
      ),
      body: !_isLoaded
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orderProvider.myOrders.length,
              itemBuilder: (ctx, i) => OrderItem(orderProvider.myOrders[i]),
            ),
      drawer: MainDrawer(),
    );
  }
}
