import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import '../services/ia_service.dart';  // ajuste o caminho se necessário

class ImcScreen extends StatefulWidget {
  const ImcScreen({super.key});

  @override
  State<ImcScreen> createState() => _ImcScreenState();
}

class _ImcScreenState extends State<ImcScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _alturaController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();

  double? _resultadoIMC;
  String? _classificacao;
  String? _sugestaoRefeicao;

  Future<void> _calcularERegistrarIMC() async {
    if (_formKey.currentState!.validate()) {
      final double altura = double.parse(_alturaController.text);
      final double peso = double.parse(_pesoController.text);
      final double imc = peso / (altura * altura);

      String classificacao;
      if (imc < 18.5) {
        classificacao = 'Abaixo do peso';
      } else if (imc < 25) {
        classificacao = 'Peso ideal';
      } else if (imc < 30) {
        classificacao = 'Sobrepeso';
      } else {
        classificacao = 'Obesidade';
      }

      setState(() {
        _resultadoIMC = imc;
        _classificacao = classificacao;
        _sugestaoRefeicao = null; // limpa sugestão antiga enquanto carrega a nova
      });

      final db = await DatabaseHelper().database;
      await db.insert('imcs', {
        'altura': altura,
        'peso': peso,
        'imc': imc,
        'data': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      });

      try {
        final sugestoes = await IaService.obterSugestoesRefeicoes(imc);
        setState(() {
          _sugestaoRefeicao = sugestoes.join('\n');
        });
      } catch (e) {
        setState(() {
          _sugestaoRefeicao = 'Erro ao obter sugestões da IA.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cálculo de IMC')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _alturaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Altura (em metros)'),
                validator: (val) => val == null || val.isEmpty ? 'Informe sua altura' : null,
              ),
              TextFormField(
                controller: _pesoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Peso (em kg)'),
                validator: (val) => val == null || val.isEmpty ? 'Informe seu peso' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularERegistrarIMC,
                child: const Text('Calcular IMC'),
              ),
              const SizedBox(height: 20),
              if (_resultadoIMC != null) ...[
                Text('IMC: ${_resultadoIMC!.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18)),
                Text('Classificação: $_classificacao',
                    style: const TextStyle(fontSize: 18)),
              ],
              if (_sugestaoRefeicao != null) ...[
                const SizedBox(height: 20),
                const Text('Sugestões de Refeição:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(_sugestaoRefeicao!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
