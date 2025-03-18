import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:terra_fertil/exception/auth_exception.dart';
import 'package:terra_fertil/models/auth.dart';
import 'package:provider/provider.dart';

enum AuthMode { SignUp, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  AuthMode _authMode = AuthMode.Login;
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  final Map<String, String> _authData = {'email': '', 'password': ''};

  bool _isLogin() => _authMode == AuthMode.Login;

  bool _isSignUp() => _authMode == AuthMode.SignUp;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.SignUp;
      } else {
        _authMode = AuthMode.Login;
      }
    });
  }

  void _showDialog(String msg) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text('Ocorreu um erro.'),
          content: Text(msg),
          actions: [
            CupertinoDialogAction(
              child: const Text("Fechar"),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
          title: Text('Ocorreu um erro.'),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Fechar'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isLoading = true);
    _formKey.currentState?.save();

    final auth = Provider.of<Auth>(context, listen: false);
    try {
      if (_isLogin()) {
        await auth.signin(_authData['email']!, _authData['password']!);
      } else {
        await auth.signup(_authData['email']!, _authData['password']!);
      }
    } on AuthException catch (errors) {
      _showDialog(errors.toString());
    } catch (errors) {
      _showDialog('Ocorreu um erro inesperado.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        height: _isLogin() ? 310 : 400,
        width: deviceSize.width * 0.8,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: _buildInputDecoration('E-mail'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um e-mail válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                decoration: _buildInputDecoration('Senha'),
                textInputAction: TextInputAction.next,
                controller: _passwordController,
                obscureText: true,
                onSaved: (password) => _authData['password'] = password ?? '',
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.isEmpty || password.length < 6) {
                    return 'Informe uma senha válida (mín. 6 caracteres).';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              if (_isSignUp())
                TextFormField(
                  decoration: _buildInputDecoration('Confirmar Senha'),
                  obscureText: true,
                  validator: (_confirmPassword) {
                    final confirmPassword = _confirmPassword ?? '';
                    if (confirmPassword != _passwordController.text) {
                      return 'As senhas não conferem.';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 15),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 8,
                    ),
                  ),
                  child: Text(_isLogin() ? 'Entrar' : 'Registrar'),
                ),
              const Spacer(),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                  _isLogin()
                      ? 'Não possui conta? REGISTRAR'
                      : 'Já possui conta? ENTRAR',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
