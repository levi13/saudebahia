import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import 'nota_form_screen.dart';

class NotasListScreen extends StatefulWidget {
  const NotasListScreen({super.key});

  @override
  State<NotasListScreen> createState() => _NotasListScreenState();
}

class _NotasListScreenState extends State<NotasListScreen> {
  List<Map<String, dynamic>> _notas = [];

  @override
  void initState() {
    super.initState();
    _carregarNotas();
  }

  Future<void> _carregarNotas() async {
    final db = await DatabaseHelper().database;
    final notas = await db.query('notas', orderBy: 'id DESC');
    setState(() {
      _notas = notas;
    });
  }

  Future<void> _deletarNota(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('notas', where: 'id = ?', whereArgs: [id]);
    await _carregarNotas();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nota deletada!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas'),
      ),
      body: _notas.isEmpty
          ? const Center(child: Text('Nenhuma nota cadastrada.'))
          : ListView.builder(
              itemCount: _notas.length,
              itemBuilder: (context, index) {
                final nota = _notas[index];
                return ListTile(
                  title: Text(nota['titulo'] ?? ''),
                  subtitle: Text(nota['conteudo'] ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deletarNota(nota['id']),
                  ),
                  onTap: () async {
                    // Abre a tela de edição da nota
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NotaFormScreen(nota: nota),
                      ),
                    );
                    _carregarNotas();
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotaFormScreen()),
          );
          _carregarNotas();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
