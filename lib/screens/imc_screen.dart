import 'package:flutter/material.dart';
import 'dart:math';

class ImcScreen extends StatefulWidget {
  const ImcScreen({super.key});

  @override
  State<ImcScreen> createState() => _ImcScreenState();
}

class _ImcScreenState extends State<ImcScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();

  double? _imc;
  String? _classificacao;

  void _calcularImc() {
    if (_formKey.currentState!.validate()) {
      final peso = double.parse(_pesoController.text);
      final alturaCm = double.parse(_alturaController.text);
      final alturaM = alturaCm / 100;

      final imc = peso / pow(alturaM, 2);
      String classificacao;

      if (imc < 18.5) {
        classificacao = 'Abaixo do peso';
      } else if (imc < 25) {
        classificacao = 'Peso normal';
      } else if (imc < 30) {
        classificacao = 'Sobrepeso';
      } else if (imc < 35) {
        classificacao = 'Obesidade grau I';
      } else if (imc < 40) {
        classificacao = 'Obesidade grau II';
      } else {
        classificacao = 'Obesidade grau III';
      }

      setState(() {
        _imc = imc;
        _classificacao = classificacao;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cálculo de IMC')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _pesoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o peso' : null,
              ),
              TextFormField(
                controller: _alturaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Altura (cm)'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe a altura' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularImc,
                child: const Text('Calcular IMC'),
              ),
              const SizedBox(height: 20),
              if (_imc != null)
                Column(
                  children: [
                    Text(
                      'IMC: ${_imc!.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Classificação: $_classificacao',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
