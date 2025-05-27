import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class ExerciciosScreen extends StatefulWidget {
  const ExerciciosScreen({super.key});

  @override
  State<ExerciciosScreen> createState() => _ExerciciosScreenState();
}

class _ExerciciosScreenState extends State<ExerciciosScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _tempoController = TextEditingController();

  String _intensidadeSelecionada = 'Leve';

  Future<void> _salvarExercicio() async {
    if (_formKey.currentState!.validate()) {
      final db = await DatabaseHelper().database;

      await db.insert('exercicios', {
        'nome': _nomeController.text,
        'descricao': _descricaoController.text,
        'intensidade': _intensidadeSelecionada,
        'tempo': int.parse(_tempoController.text), // novo campo
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exercício salvo com sucesso!')),
      );

      _nomeController.clear();
      _descricaoController.clear();
      _tempoController.clear();
      setState(() {
        _intensidadeSelecionada = 'Leve';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Exercício')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe a descrição' : null,
              ),
              DropdownButtonFormField<String>(
                value: _intensidadeSelecionada,
                decoration: const InputDecoration(labelText: 'Intensidade'),
                items: const [
                  DropdownMenuItem(value: 'Leve', child: Text('Leve')),
                  DropdownMenuItem(value: 'Moderado', child: Text('Moderado')),
                  DropdownMenuItem(value: 'Alta Intensidade', child: Text('Alta Intensidade')),
                ],
                onChanged: (value) {
                  setState(() {
                    _intensidadeSelecionada = value!;
                  });
                },
              ),
              TextFormField(
                controller: _tempoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Tempo (minutos)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o tempo';
                  }
                  final tempo = int.tryParse(value);
                  if (tempo == null || tempo <= 0) {
                    return 'Tempo inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvarExercicio,
                child: const Text('Salvar Exercício'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
