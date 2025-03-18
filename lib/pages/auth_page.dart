import 'dart:math';
import 'package:flutter/material.dart';
import 'package:terra_fertil/components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height, // ocupa toda a tela
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Theme.of(context).colorScheme.secondary,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Terra Fertil',
                  style: TextStyle(
                    fontSize: 45,
                    fontFamily: 'Anton',
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const AuthForm(),
            ],
          ),
        ),
      ),
    );
  }
}
