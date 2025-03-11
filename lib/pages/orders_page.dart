import 'package:flutter/material.dart';
import 'package:terra_fertil/components/app_drawer.dart';
import 'package:terra_fertil/components/order.dart';
import 'package:terra_fertil/models/order_list.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Pedidos", style: TextStyle(fontSize: 18)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: orders.itemsCount,
          itemBuilder: (ctx, i) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: OrderWidget(order: orders.items[i]),
          ),
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
