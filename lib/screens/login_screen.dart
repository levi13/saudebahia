import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _senha = '';
  bool _isLogin = true;

  Future<void> _autenticarOuCadastrar() async {
    final db = await DatabaseHelper().database;

    if (_isLogin) {
      final result = await db.query(
        'administradores',
        where: 'email = ? AND senha = ?',
        whereArgs: [_email, _senha],
      );

      if (result.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login realizado com sucesso!')),
        );
        Navigator.pushNamed(context, '/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('E-mail ou senha incorretos')),
        );
      }
    } else {
      await db.insert('administradores', {
        'nome': 'Admin',
        'email': _email,
        'senha': _senha,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Administrador cadastrado com sucesso!')),
      );

      setState(() {
        _isLogin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (val) =>
                    val!.isEmpty ? 'Informe seu e-mail' : null,
                onSaved: (val) => _email = val!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (val) =>
                    val!.isEmpty ? 'Informe sua senha' : null,
                onSaved: (val) => _senha = val!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _autenticarOuCadastrar();
                  }
                },
                child: Text(_isLogin ? 'Entrar' : 'Cadastrar'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLogin = !_isLogin;
                  });
                },
                child: Text(_isLogin
                    ? 'Não tem conta? Cadastre-se'
                    : 'Já tem conta? Entrar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
