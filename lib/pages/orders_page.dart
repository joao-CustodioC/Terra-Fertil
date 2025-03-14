import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terra_fertil/components/app_drawer.dart';
import 'package:terra_fertil/components/order.dart';
import 'package:terra_fertil/models/order_list.dart';

class OrdersPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<OrderList>(context, listen: false).loadOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar:
          Platform.isIOS
              ? CupertinoNavigationBar(
                leading: GestureDetector(
                  onTap: _openDrawer,
                  child: const Icon(
                    CupertinoIcons.bars,
                    color: CupertinoColors.white,
                  ),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                middle: const Text(
                  'Meus Pedidos',
                  style: TextStyle(color: CupertinoColors.white),
                ),
              )
              : AppBar(
                title: const Text(
                  "Meus Pedidos",
                  style: TextStyle(fontSize: 18),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 4,
              ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: FutureBuilder(
          future: Provider.of<OrderList>(context, listen: false).loadOrder(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Consumer<OrderList>(
                  builder:
                      (ctx, orders, child) => ListView.builder(
                        itemCount: orders.itemsCount,
                        itemBuilder:
                            (ctx, i) => Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 8,
                              ),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: OrderWidget(order: orders.items[i]),
                            ),
                      ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
