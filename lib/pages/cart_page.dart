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

  Widget buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Seu carrinho está vazio!", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          Platform.isIOS
              ? CupertinoButton.filled(
            child: const Text("Ir para a loja"),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH_OR_HOME);
            },
          )
              : ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: const Text(
              "Ir para a loja",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH_OR_HOME);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final items = cart.items.values.toList();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          color: CupertinoColors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        middle: const Text(
          'Carrinho',
          style: TextStyle(color: CupertinoColors.white),
        ),
      )
          : AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Carrinho", style: TextStyle(fontSize: 18)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4,
      ),
      body: items.isEmpty
          ? buildEmptyCart(context)
          : Column(
        children: [
          // Sumário do Carrinho
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 25,
            ),
            padding: const EdgeInsets.all(15),
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
            child: Row(
              children: [
                const Text("Total", style: TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Chip(
                  label: Text(
                    'R\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                CartButton(cart: cart),
              ],
            ),
          ),
          // Lista de Itens
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: items.length,
              separatorBuilder: (ctx, i) => const Divider(),
              itemBuilder: (ctx, i) => CartItemWidget(cartItem: items[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class CartButton extends StatefulWidget {
  const CartButton({Key? key, required this.cart}) : super(key: key);

  final Cart cart;

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    return _isloading
        ? const CircularProgressIndicator()
        : Platform.isIOS
        ? CupertinoButton(
      padding: EdgeInsets.zero,
      child: Text(
        "COMPRAR",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      onPressed: () async {
        setState(() => _isloading = true);
        try {
          await Provider.of<OrderList>(context, listen: false)
              .addOrder(widget.cart);
          widget.cart.clear();
          Navigator.of(context).pushNamed(AppRoutes.ORDERS);
        } catch (error) {
          debugPrint("Erro ao adicionar pedido: $error");
        } finally {
          setState(() => _isloading = false);
        }
      },
    )
        : TextButton(
      onPressed: () async {
        setState(() => _isloading = true);
        try {
          await Provider.of<OrderList>(context, listen: false)
              .addOrder(widget.cart);
          widget.cart.clear();
          Navigator.of(context).pushNamed(AppRoutes.ORDERS);
        } catch (error) {
          debugPrint("Erro ao adicionar pedido: $error");
        } finally {
          setState(() => _isloading = false);
        }
      },
      style: TextButton.styleFrom(
        textStyle:
        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      child: const Text("COMPRAR"),
    );
  }
}
