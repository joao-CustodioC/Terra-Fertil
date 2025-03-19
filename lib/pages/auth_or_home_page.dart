import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terra_fertil/models/auth.dart';
import 'package:terra_fertil/pages/auth_page.dart';
import 'package:terra_fertil/pages/products_overview_page.dart';

class AuthOrHomePage extends StatefulWidget {
  const AuthOrHomePage({super.key});

  @override
  State<AuthOrHomePage> createState() => _AuthOrHomePageState();
}

class _AuthOrHomePageState extends State<AuthOrHomePage> {
  late Future<void> _authFuture;

  @override
  void initState() {
    super.initState();
    _authFuture = Provider.of<Auth>(context, listen: false).tryAutoLogin();
  }

  void _retryAuth() {
    setState(() {
      _authFuture = Provider.of<Auth>(context, listen: false).tryAutoLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return FutureBuilder(
      future: _authFuture,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/auth_bg.png'),
                  SizedBox(height: 20),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ],
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error, size: 80, color: Colors.redAccent),
                  SizedBox(height: 20),
                  Text(
                    'Ocorreu um erro!',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.redAccent,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _retryAuth,
                    child: Text('Tentar Novamente'),
                  ),
                ],
              ),
            ),
          );
        } else {
          return auth.isAuth ? ProductsOverviewPage() : AuthPage();
        }
      },
    );
  }
}
