import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';

class RelatoriosScreen extends StatefulWidget {
  const RelatoriosScreen({super.key});

  @override
  State<RelatoriosScreen> createState() => _RelatoriosScreenState();
}

class _RelatoriosScreenState extends State<RelatoriosScreen> {
  int _totalSemana = 0;
  int _totalMes = 0;

  @override
  void initState() {
    super.initState();
    _carregarRelatorios();
  }

  Future<void> _carregarRelatorios() async {
    final db = await DatabaseHelper().database;

    // Datas de hoje, 7 dias atrás e 30 dias atrás
    final hoje = DateTime.now();
    final seteDiasAtras = hoje.subtract(const Duration(days: 7));
    final trintaDiasAtras = hoje.subtract(const Duration(days: 30));

    // Consultar refeições da semana
    final semana = await db.rawQuery('''
      SELECT COUNT(*) as total FROM refeicoes
      WHERE DATE(data) >= DATE(?)
    ''', [seteDiasAtras.toIso8601String()]);

    // Consultar refeições do mês
    final mes = await db.rawQuery('''
      SELECT COUNT(*) as total FROM refeicoes
      WHERE DATE(data) >= DATE(?)
    ''', [trintaDiasAtras.toIso8601String()]);

    setState(() {
      _totalSemana = semana.first['total'] as int;
      _totalMes = mes.first['total'] as int;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios de Refeições')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard('Últimos 7 dias', _totalSemana),
            const SizedBox(height: 16),
            _buildCard('Últimos 30 dias', _totalMes),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String titulo, int total) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(titulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text('Total de refeições: $total', style: const TextStyle(fontSize: 16)),
        leading: const Icon(Icons.bar_chart, color: Colors.green),
      ),
    );
  }
}
