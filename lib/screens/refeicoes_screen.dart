import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class RefeicoesScreen extends StatefulWidget {
  const RefeicoesScreen({super.key});

  @override
  State<RefeicoesScreen> createState() => _RefeicoesScreenState();
}

class _RefeicoesScreenState extends State<RefeicoesScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  DateTime _dataSelecionada = DateTime.now();

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dataSelecionada) {
      setState(() {
        _dataSelecionada = picked;
      });
    }
  }

  Future<void> _salvarRefeicao() async {
    if (_formKey.currentState!.validate()) {
      final db = await DatabaseHelper().database;
      await db.insert('refeicoes', {
        'titulo': _tituloController.text,
        'descricao': _descricaoController.text,
        'data': _dataSelecionada.toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Refeição salva com sucesso!')),
      );

      _tituloController.clear();
      _descricaoController.clear();
      setState(() {
        _dataSelecionada = DateTime.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Refeição'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (val) => val == null || val.isEmpty ? 'Informe o título' : null,
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (val) => val == null || val.isEmpty ? 'Informe a descrição' : null,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text("Data: ${_dataSelecionada.toLocal().toString().split(' ')[0]}"),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _selecionarData(context),
                    child: const Text('Selecionar data'),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _salvarRefeicao,
                child: const Text('Salvar Refeição'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
