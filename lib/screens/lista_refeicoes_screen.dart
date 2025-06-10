import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class ListaRefeicoesScreen extends StatefulWidget {
  const ListaRefeicoesScreen({super.key});

  @override
  State<ListaRefeicoesScreen> createState() => _ListaRefeicoesScreenState();
}

class _ListaRefeicoesScreenState extends State<ListaRefeicoesScreen> {
  List<Map<String, dynamic>> _refeicoes = [];
  DateTime? _dataSelecionada;

  @override
  void initState() {
    super.initState();
    _carregarRefeicoes();
  }

  Future<void> _carregarRefeicoes({DateTime? dataFiltro}) async {
    final db = await DatabaseHelper().database;
    String whereString = '';
    List<dynamic> whereArgs = [];

    if (dataFiltro != null) {
      final dataInicio = DateTime(dataFiltro.year, dataFiltro.month, dataFiltro.day);
      final dataFim = dataInicio.add(const Duration(days: 1));
      whereString = 'data >= ? AND data < ?';
      whereArgs = [dataInicio.toIso8601String(), dataFim.toIso8601String()];
    }

    final List<Map<String, dynamic>> dados = await db.query(
      'refeicoes',
      where: whereString.isNotEmpty ? whereString : null,
      whereArgs: whereArgs.isNotEmpty ? whereArgs : null,
      orderBy: 'data DESC',
    );

    setState(() {
      _refeicoes = dados;
    });
  }

  String _formatarData(String isoString) {
    final date = DateTime.parse(isoString);
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? data = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (data != null) {
      setState(() {
        _dataSelecionada = data;
      });
      await _carregarRefeicoes(dataFiltro: data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Refeições'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _selecionarData(context),
            tooltip: 'Selecionar Data',
          ),
        ],
      ),
      body: _refeicoes.isEmpty
          ? const Center(child: Text('Nenhuma refeição cadastrada.'))
          : ListView.builder(
              itemCount: _refeicoes.length,
              itemBuilder: (context, index) {
                final refeicao = _refeicoes[index];
                return ListTile(
                  title: Text(refeicao['titulo'] ?? ''),
                  subtitle: Text(refeicao['descricao'] ?? ''),
                  trailing: Text(_formatarData(refeicao['data'] ?? '')),
                );
              },
            ),
    );
  }
}
