import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:terra_fertil/components/cart_item.dart';
import 'package:terra_fertil/models/cart.dart';
import 'package:provider/provider.dart';
import 'package:terra_fertil/models/order_list.dart';
import 'package:terra_fertil/utils/app_routes.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    final items = cart.items.values.toList();

    Widget buildEmptyCart() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Seu carrinho está vazio!",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Platform.isIOS
                ? CupertinoButton.filled(
              child: Text("Ir para a loja"),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.HOME);
              },
            )
                : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Text("Ir para a loja"),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.HOME);
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          color: CupertinoColors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        middle: Text(
          'Carrinho',
          style: TextStyle(color: CupertinoColors.white),
        ),
      )
          : AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Carrinho", style: TextStyle(fontSize: 18)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4,
      ),
      body: items.isEmpty
          ? buildEmptyCart()
          : Column(
        children: [
          Card(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Text("Total", style: TextStyle(fontSize: 20)),
                  SizedBox(width: 10),
                  Chip(
                    label: Text(
                      'R\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  Platform.isIOS
                      ? CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text(
                      "COMPRAR",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .colorScheme
                            .secondary,
                      ),
                    ),
                    onPressed: () {
                      Provider.of<OrderList>(
                        context,
                        listen: false,
                      ).addOrder(cart);
                      cart.clear();
                    },
                  )
                      : TextButton(
                    onPressed: () {
                      Provider.of<OrderList>(
                        context,
                        listen: false,
                      ).addOrder(cart);
                      cart.clear();
                    },
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Text("COMPRAR"),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemCount: items.length,
              separatorBuilder: (ctx, i) => Divider(),
              itemBuilder: (ctx, i) =>
                  CartItemWigdet(cartItem: items[i]),
            ),
          ),
        ],
      ),
    );
  }
}
