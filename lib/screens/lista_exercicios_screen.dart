import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';

class ListaExerciciosScreen extends StatefulWidget {
  const ListaExerciciosScreen({super.key});

  @override
  State<ListaExerciciosScreen> createState() => _ListaExerciciosScreenState();
}

class _ListaExerciciosScreenState extends State<ListaExerciciosScreen> {
  List<Map<String, dynamic>> _exercicios = [];
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _carregarExercicios();
  }

  Future<void> _carregarExercicios() async {
    final db = await DatabaseHelper().database;
    String query = 'SELECT * FROM exercicios';
    List<dynamic> args = [];

    // Filtro de datas
    if (_startDate != null && _endDate != null) {
      query += ' WHERE data >= ? AND data <= ?';
      args = [_startDate!.toIso8601String(), _endDate!.toIso8601String()];
    }

    query += ' ORDER BY id DESC';
    
    final dados = await db.rawQuery(query, args);
    setState(() {
      _exercicios = dados;
    });
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTime? pickedStart = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedStart != null && pickedStart != _startDate) {
      final DateTime? pickedEnd = await showDatePicker(
        context: context,
        initialDate: _endDate ?? pickedStart,
        firstDate: pickedStart,
        lastDate: DateTime(2101),
      );

      if (pickedEnd != null && pickedEnd != _endDate) {
        setState(() {
          _startDate = pickedStart;
          _endDate = pickedEnd;
        });
        _carregarExercicios();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercícios Cadastrados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              _selectDateRange(context);
            },
          ),
        ],
      ),
      body: _exercicios.isEmpty
          ? const Center(child: Text('Nenhum exercício cadastrado.'))
          : ListView.builder(
              itemCount: _exercicios.length,
              itemBuilder: (context, index) {
                final exercicio = _exercicios[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(exercicio['nome'] ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Descrição: ${exercicio['descricao'] ?? ''}'),
                        Text('Intensidade: ${exercicio['intensidade'] ?? ''}'),
                        Text('Tempo: ${exercicio['tempo'] ?? 0} min'),
                        Text('Data: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(exercicio['data']))}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
