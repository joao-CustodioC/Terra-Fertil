import 'package:flutter/material.dart';
import 'package:terra_fertil/models/auth.dart';
import 'package:terra_fertil/models/cart.dart';
import 'package:terra_fertil/models/order_list.dart';
import 'package:terra_fertil/models/product_list.dart';
import 'package:terra_fertil/pages/auth_or_home_page.dart';
import 'package:terra_fertil/pages/cart_page.dart';
import 'package:terra_fertil/pages/orders_page.dart';
import 'package:terra_fertil/pages/product_form_page.dart';
import 'package:terra_fertil/pages/product_page.dart';
import 'package:terra_fertil/utils/app_routes.dart';
import 'package:terra_fertil/pages/product_detail_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList(),
          update:
              (ctx, auth, previous) =>
                  ProductList(auth.token ?? '', previous?.items ?? [], auth.userId ?? ''),
        ),
        ChangeNotifierProxyProvider<Auth, OrderList>(
          create: (_) => OrderList(),
          update:
              (ctx, auth, previous) =>
                  OrderList(auth.token ?? '', previous?.items ?? [], auth.userId ?? ''),
        ),
        ChangeNotifierProvider(create: (_) => Cart()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Terra Fértil',
        theme: ThemeData(
          primaryColor: Color(0xFF1F1B24),
          scaffoldBackgroundColor: Color(0xFFE0E0E0),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Color(0xFF1F1B24),
            secondary: Color(0xFF8D6E63),
            background: Color(0xFFE0E0E0),
            surface: Colors.white,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: Colors.black87,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF1F1B24),
            foregroundColor: Colors.white,
            elevation: 4,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          textTheme: TextTheme(
            bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
            bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
            titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        routes: {
          AppRoutes.AUTH_OR_HOME: (ctx) => AuthOrHomePage(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailPage(),
          AppRoutes.CART: (ctx) => CartPage(),
          AppRoutes.ORDERS: (ctx) => OrdersPage(),
          AppRoutes.PRODUCTS: (ctx) => ProductPage(),
          AppRoutes.PRODUCTS_FORM: (ctx) => ProductFormPage(),
        },
      ),
    );
  }
}
