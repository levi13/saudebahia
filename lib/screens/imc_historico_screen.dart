import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class ImcHistoricoScreen extends StatefulWidget {
  const ImcHistoricoScreen({super.key});

  @override
  State<ImcHistoricoScreen> createState() => _ImcHistoricoScreenState();
}

class _ImcHistoricoScreenState extends State<ImcHistoricoScreen> {
  List<Map<String, dynamic>> _historico = [];

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  Future<void> _carregarHistorico() async {
    final db = await DatabaseHelper().database;
    final dados = await db.query('imc', orderBy: 'data DESC');
    setState(() {
      _historico = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Histórico de IMC')),
      body: _historico.isEmpty
          ? Center(child: Text('Nenhum registro de IMC encontrado.'))
          : ListView.builder(
              itemCount: _historico.length,
              itemBuilder: (context, index) {
                final item = _historico[index];
                return ListTile(
                  title: Text('IMC: ${item['imc'].toStringAsFixed(2')} - ${item['resultado']}'),
                  subtitle: Text(
                      'Peso: ${item['peso']} kg, Altura: ${item['altura']} m\nData: ${DateTime.parse(item['data']).toLocal().toString().split('.')[0]}'),
                );
              },
            ),
    );
  }
}
