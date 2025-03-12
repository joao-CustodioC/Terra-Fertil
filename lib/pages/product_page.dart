import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:terra_fertil/components/app_drawer.dart';
import 'package:terra_fertil/components/product_item.dart';
import 'package:terra_fertil/models/product_list.dart';
import 'package:terra_fertil/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productList = Provider.of<ProductList>(context);
    final primaryColor = Theme.of(context).primaryColor;
    // Chave global para controlar o Drawer em iOS
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
        // Ícone de menu para abrir o Drawer no iOS
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: const Icon(
            CupertinoIcons.bars,
            color: CupertinoColors.white,
          ),
        ),
        middle: const Text(
          "Gerenciar Produtos",
          style: TextStyle(color: CupertinoColors.white),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(
            CupertinoIcons.add,
            color: CupertinoColors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.PRODUCTS_FORM);
          },
        ),
        backgroundColor: primaryColor,
      )
          : AppBar(
        title: const Text(
          "Gerenciar Produtos",
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: primaryColor,
        elevation: 4,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PRODUCTS_FORM);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: productList.items.length,
          itemBuilder: (ctx, i) => Column(
            children: [
              ProductItem(productList.items[i]),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
