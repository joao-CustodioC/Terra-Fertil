import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terra_fertil/models/product.dart';
import 'package:terra_fertil/models/product_list.dart';
import 'package:terra_fertil/utils/app_routes.dart';

import '../exception/http_exception.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem(this.product, {Key? key}) : super(key: key);

  void _editProduct(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoutes.PRODUCTS_FORM,
      arguments: product,
    );
  }

  void _deleteProduct(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);

    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text("Tem Certeza"),
          content: const Text("Quer excluir o produto?"),
          actions: [
            CupertinoDialogAction(
              child: const Text("Não"),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text("Sim"),
              onPressed: () async {
                try {
                  await Provider.of<ProductList>(context, listen: false)
                      .removeProduct(product);
                } on HttpExceptionn catch (error) {
                  msg.showSnackBar(SnackBar(content: Text(error.toString())));
                } finally {
                  Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Tem Certeza"),
          content: const Text("Quer excluir o produto?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Não"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await Provider.of<ProductList>(context, listen: false)
                      .removeProduct(product);
                } on HttpExceptionn catch (error) {
                  msg.showSnackBar(SnackBar(content: Text(error.toString())));
                } finally {
                  Navigator.of(ctx).pop();
                }
              },
              child: const Text("Sim"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
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
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(product.imageUrl),
        ),
        title: Text(product.title),
        trailing: SizedBox(
          width: 100,
          child: Row(
            children: [
              // Botão Editar
              if (Platform.isIOS)
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(CupertinoIcons.pencil, color: primaryColor),
                  onPressed: () => _editProduct(context),
                )
              else
                IconButton(
                  icon: Icon(Icons.edit, color: primaryColor),
                  onPressed: () => _editProduct(context),
                ),
              // Botão Excluir
              if (Platform.isIOS)
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(
                    CupertinoIcons.delete,
                    color: CupertinoColors.destructiveRed,
                  ),
                  onPressed: () => _deleteProduct(context),
                )
              else
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _deleteProduct(context),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
