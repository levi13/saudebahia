import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class PesoScreen extends StatefulWidget {
  const PesoScreen({super.key});

  @override
  State<PesoScreen> createState() => _PesoScreenState();
}

class _PesoScreenState extends State<PesoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pesoController = TextEditingController();

  Future<void> _salvarPeso() async {
    if (_formKey.currentState!.validate()) {
      final peso = double.parse(_pesoController.text);

      final db = await DatabaseHelper().database;
      await db.insert('imcs', {
        'peso': peso,
        'altura': 0.0, // altura e imc zerados porque só queremos registrar o peso
        'imc': 0.0,
        'data': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Peso salvo com sucesso!')),
      );

      _pesoController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Peso')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _pesoController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o peso';
                  }
                  final peso = double.tryParse(value);
                  if (peso == null || peso <= 0) {
                    return 'Peso inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _salvarPeso,
                child: const Text('Salvar Peso'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
