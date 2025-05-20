import 'package:flutter/material.dart';
import '../db/database_helper.dart';

class NotaFormScreen extends StatefulWidget {
  final Map<String, dynamic>? nota;
  const NotaFormScreen({super.key, this.nota});

  @override
  State<NotaFormScreen> createState() => _NotaFormScreenState();
}

class _NotaFormScreenState extends State<NotaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _conteudoController;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.nota?['titulo'] ?? '');
    _conteudoController = TextEditingController(text: widget.nota?['conteudo'] ?? '');
  }

  Future<void> _salvarNota() async {
    if (_formKey.currentState!.validate()) {
      final db = await DatabaseHelper().database;
      if (widget.nota == null) {
        // Inserir nova nota
        await db.insert('notas', {
          'titulo': _tituloController.text,
          'conteudo': _conteudoController.text,
        });
      } else {
        // Atualizar nota existente
        await db.update(
          'notas',
          {
            'titulo': _tituloController.text,
            'conteudo': _conteudoController.text,
          },
          where: 'id = ?',
          whereArgs: [widget.nota!['id']],
        );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nota == null ? 'Adicionar Nota' : 'Editar Nota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (val) => val == null || val.isEmpty ? 'Informe o título' : null,
              ),
              TextFormField(
                controller: _conteudoController,
                decoration: const InputDecoration(labelText: 'Conteúdo'),
                maxLines: 5,
                validator: (val) => val == null || val.isEmpty ? 'Informe o conteúdo' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarNota,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
