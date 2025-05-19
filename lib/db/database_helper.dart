import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  // Criar o banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Se o banco não existir, cria um novo
    _database = await _initDB();
    return _database!;
  }

  // Inicialização do banco de dados
  _initDB() async {
    String path = join(await getDatabasesPath(), 'saudebahia.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Criação das tabelas
  _onCreate(Database db, int version) async {
    // Tabela de administradores
    await db.execute('''
      CREATE TABLE administradores(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        email TEXT UNIQUE,
        senha TEXT
      )
    ''');

    // Tabela de pesos
    await db.execute('''
      CREATE TABLE pesos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        peso REAL,
        data TEXT
      )
    ''');

    // Tabela de refeições
    await db.execute('''
      CREATE TABLE refeicoes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT,
        descricao TEXT,
        data TEXT
      )
    ''');

    // Tabela de exercícios
    await db.execute('''
      CREATE TABLE exercicios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        descricao TEXT
      )
    ''');

    // Tabela de objetivos
    await db.execute('''
      CREATE TABLE objetivos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        objetivo TEXT
      )
    ''');

    // Tabela de notas
    await db.execute('''
      CREATE TABLE notas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT,
        conteudo TEXT
      )
    ''');
    await db.execute('''
  CREATE TABLE IF NOT EXISTS imc (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    peso REAL,
    altura REAL,
    imc REAL,
    resultado TEXT,
    data TEXT
  )
''');

  }

  // Função para fechar o banco de dados
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
