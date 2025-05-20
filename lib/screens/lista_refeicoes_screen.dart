import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class ListaRefeicoesScreen extends StatefulWidget {
  const ListaRefeicoesScreen({super.key});

  @override
  State<ListaRefeicoesScreen> createState() => _ListaRefeicoesScreenState();
}

class _ListaRefeicoesScreenState extends State<ListaRefeicoesScreen> {
  List<Map<String, dynamic>> _refeicoes = [];

  @override
  void initState() {
    super.initState();
    _carregarRefeicoes();
  }

  Future<void> _carregarRefeicoes() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> dados = await db.query('refeicoes', orderBy: 'data DESC');
    setState(() {
      _refeicoes = dados;
    });
  }

  String _formatarData(String isoString) {
    final date = DateTime.parse(isoString);
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Refeições'),
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
