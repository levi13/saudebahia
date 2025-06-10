import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';

class RelatoriosScreen extends StatefulWidget {
  const RelatoriosScreen({super.key});

  @override
  State<RelatoriosScreen> createState() => _RelatoriosScreenState();
}

class _RelatoriosScreenState extends State<RelatoriosScreen> {
  int _totalRefeicoesSemana = 0;
  int _totalRefeicoesMes = 0;
  int _totalExerciciosSemana = 0;
  int _totalExerciciosMes = 0;

  @override
  void initState() {
    super.initState();
    _carregarRelatorios();
  }

  Future<void> _carregarRelatorios() async {
    final db = await DatabaseHelper().database;

    final hoje = DateTime.now();
    final seteDiasAtras = hoje.subtract(const Duration(days: 7));
    final trintaDiasAtras = hoje.subtract(const Duration(days: 30));

    // Consultar refeições
    final semanaRefeicoes = await db.rawQuery('''
      SELECT COUNT(*) as total FROM refeicoes
      WHERE DATE(data) >= DATE(?)
    ''', [seteDiasAtras.toIso8601String()]);

    final mesRefeicoes = await db.rawQuery('''
      SELECT COUNT(*) as total FROM refeicoes
      WHERE DATE(data) >= DATE(?)
    ''', [trintaDiasAtras.toIso8601String()]);

    // Consultar exercícios
    final semanaExercicios = await db.rawQuery('''
      SELECT COUNT(*) as total FROM exercicios
      WHERE DATE(data) >= DATE(?)
    ''', [seteDiasAtras.toIso8601String()]);

    final mesExercicios = await db.rawQuery('''
      SELECT COUNT(*) as total FROM exercicios
      WHERE DATE(data) >= DATE(?)
    ''', [trintaDiasAtras.toIso8601String()]);

    setState(() {
      _totalRefeicoesSemana = semanaRefeicoes.first['total'] as int;
      _totalRefeicoesMes = mesRefeicoes.first['total'] as int;
      _totalExerciciosSemana = semanaExercicios.first['total'] as int;
      _totalExerciciosMes = mesExercicios.first['total'] as int;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios Semanais e Mensais')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Últimos 7 dias', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildCard('Refeições', _totalRefeicoesSemana, Icons.restaurant),
            _buildCard('Exercícios', _totalExerciciosSemana, Icons.fitness_center),
            const SizedBox(height: 24),
            const Text('Últimos 30 dias', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildCard('Refeições', _totalRefeicoesMes, Icons.restaurant_menu),
            _buildCard('Exercícios', _totalExerciciosMes, Icons.directions_run),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String titulo, int total, IconData icone) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(titulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text('Total: $total', style: const TextStyle(fontSize: 16)),
        leading: Icon(icone, color: Colors.blue),
      ),
    );
  }
}
