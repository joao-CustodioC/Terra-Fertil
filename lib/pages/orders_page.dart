import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terra_fertil/components/app_drawer.dart';
import 'package:terra_fertil/components/order.dart';
import 'package:terra_fertil/models/order_list.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  // Chave global para controlar o Scaffold (abrir o Drawer manualmente no iOS)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrderList>(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.background,
      // AppBar adaptado para iOS e Android
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
        // Ícone de menu para abrir o drawer no iOS
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: orders.itemsCount,
          itemBuilder: (ctx, i) => Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: OrderWidget(order: orders.items[i]),
          ),
        ),
      ),
    );
  }
}
