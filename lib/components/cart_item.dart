import 'package:flutter/material.dart';
import 'package:terra_fertil/models/cart.dart';
import 'package:terra_fertil/models/cart_item.dart';
import 'package:provider/provider.dart';

class CartItemWigdet extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWigdet({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Icon(Icons.delete, color: Colors.white, size: 40),
      ),
      onDismissed: (_) {
        Provider.of<Cart>(
          context,
          listen: false,
        ).removeItem(cartItem.productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.black,


            child: Padding(
              padding: EdgeInsets.all(5),
              child: FittedBox(
                child: Text('${cartItem.price}'
                ),
              ),
            ),
          ),
          title: Text(cartItem.title),
          subtitle: Text('Total R\$ ${(cartItem.price * cartItem.quantity)}'),
          trailing: Text('${cartItem.quantity}x'),
        ),
      ),
    );
  }
}
