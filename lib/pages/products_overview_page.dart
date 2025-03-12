import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:terra_fertil/components/app_drawer.dart';
import 'package:terra_fertil/components/badgee.dart';
import 'package:terra_fertil/components/product_grid.dart';
import 'package:provider/provider.dart';
import 'package:terra_fertil/models/cart.dart';
import 'package:terra_fertil/utils/app_routes.dart';

enum FilterOptions { Favorite, All }

class ProductsOverviewPage extends StatefulWidget {
  ProductsOverviewPage({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showFavoriteOnly = false;

  // 1. Cria uma GlobalKey para controlar o Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 2. Passa a key para o Scaffold
      key: _scaffoldKey,
      drawer: AppDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: Platform.isIOS
          ? CupertinoNavigationBar(
        // 3. Adiciona o ícone de menu para abrir o Drawer no iOS
        leading: GestureDetector(
          onTap: _openDrawer,
          child: Icon(
            CupertinoIcons.bars,
            color: CupertinoColors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        middle: Text(
          'Minha Loja',
          style: TextStyle(color: CupertinoColors.white),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(
                CupertinoIcons.settings,
                color: CupertinoColors.white,
              ),
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (_) => CupertinoActionSheet(
                    title: Text("Filtrar Produtos"),
                    actions: [
                      CupertinoActionSheetAction(
                        onPressed: () {
                          setState(() {
                            _showFavoriteOnly = true;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text("Somente Favoritos"),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () {
                          setState(() {
                            _showFavoriteOnly = false;
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text("Todos"),
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancelar"),
                    ),
                  ),
                );
              },
            ),
            Consumer<Cart>(
              builder: (ctx, cart, child) => Badgee(
                value: cart.itemsCount.toString(),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Icon(
                    CupertinoIcons.cart,
                    color: CupertinoColors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.CART);
                  },
                ),
              ),
            ),
          ],
        ),
      )
          : AppBar(
        title: Text('Minha Loja'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Consumer<Cart>(
            builder: (ctx, cart, child) => Badgee(
              value: cart.itemsCount.toString(),
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Color(0xFFFFD700),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.CART);
                },
              ),
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: FilterOptions.Favorite,
                child: Text('Somente Favoritos'),
              ),
              PopupMenuItem(
                value: FilterOptions.All,
                child: Text('Todos'),
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                _showFavoriteOnly =
                    selectedValue == FilterOptions.Favorite;
              });
            },
          ),
        ],
      ),
      body: ProductGrid(_showFavoriteOnly),
    );
  }
}
