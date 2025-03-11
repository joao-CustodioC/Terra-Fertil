import 'dart:io';
import 'package:flutter/material.dart';
import 'package:terra_fertil/components/product_grid.dart';
import 'package:terra_fertil/models/product.dart';
import 'package:provider/provider.dart';
import 'package:terra_fertil/models/product_list.dart';

class ProductGridItem extends StatelessWidget {
  final bool showFavoriteOnly;

  ProductGridItem(this.showFavoriteOnly);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProducts =
        showFavoriteOnly ? provider.favoriteItems : provider.items;
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      physics:
          Platform.isIOS ? BouncingScrollPhysics() : ClampingScrollPhysics(),
      itemCount: loadedProducts.length,
      itemBuilder:
          (ctx, i) => ChangeNotifierProvider.value(
            value: loadedProducts[i],
            child: ProductGrid(),
          ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        childAspectRatio: MediaQuery.of(context).size.width > 600 ? 0.75 : 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
    );
  }
}
