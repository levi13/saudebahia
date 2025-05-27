import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class ListaExerciciosScreen extends StatefulWidget {
  const ListaExerciciosScreen({super.key});

  @override
  State<ListaExerciciosScreen> createState() => _ListaExerciciosScreenState();
}

class _ListaExerciciosScreenState extends State<ListaExerciciosScreen> {
  List<Map<String, dynamic>> _exercicios = [];

  @override
  void initState() {
    super.initState();
    _carregarExercicios();
  }

  Future<void> _carregarExercicios() async {
    final db = await DatabaseHelper().database;
    final dados = await db.query('exercicios', orderBy: 'id DESC');
    setState(() {
      _exercicios = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercícios Cadastrados')),
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
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
