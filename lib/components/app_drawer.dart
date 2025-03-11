import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:terra_fertil/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  Widget _buildIosDrawer(BuildContext context, Color primaryColor) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor, // Fundo definido
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.7),
                    primaryColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  'Bem Vindo!',
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            CupertinoButton(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Row(
                children: [
                  Icon(CupertinoIcons.home, color: primaryColor),
                  SizedBox(width: 16),
                  Text('Loja',
                      style: TextStyle(fontSize: 18, color: primaryColor)),
                ],
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.HOME);
              },
            ),
            CupertinoButton(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Row(
                children: [
                  Icon(CupertinoIcons.square_list, color: primaryColor),
                  SizedBox(width: 16),
                  Text('Pedidos',
                      style: TextStyle(fontSize: 18, color: primaryColor)),
                ],
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.ORDERS);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAndroidDrawer(BuildContext context, Color primaryColor) {
    return Drawer(
      backgroundColor:
      Theme.of(context).scaffoldBackgroundColor, // Fundo definido
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.7),
                  primaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Bem Vindo!',
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.store, size: 28, color: primaryColor),
            title: Text(
              'Loja',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.HOME);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment, size: 28, color: primaryColor),
            title: Text(
              'Pedidos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.ORDERS);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Platform.isIOS
        ? _buildIosDrawer(context, primaryColor)
        : _buildAndroidDrawer(context, primaryColor);
  }
}
