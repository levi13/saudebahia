import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  // Getter para o banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Inicializar o banco
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'saudebahia.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Criação das tabelas
  Future<void> _onCreate(Database db, int version) async {
    // Administradores
    await db.execute('''
      CREATE TABLE administradores(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        email TEXT UNIQUE,
        senha TEXT
      )
    ''');

    // Pesos
    await db.execute('''
      CREATE TABLE pesos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        peso REAL,
        data TEXT
      )
    ''');

    // Refeições
    await db.execute('''
      CREATE TABLE refeicoes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT,
        descricao TEXT,
        data TEXT
      )
    ''');

    // Exercícios
    await db.execute('''
      CREATE TABLE exercicios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        descricao TEXT
      )
    ''');

    // Objetivos
    await db.execute('''
      CREATE TABLE objetivos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        objetivo TEXT
      )
    ''');

    // Notas
    await db.execute('''
      CREATE TABLE notas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT,
        conteudo TEXT
      )
    ''');

    // Histórico de IMC
    await db.execute('''
      CREATE TABLE imcs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        peso REAL,
        altura REAL,
        imc REAL,
        data TEXT
      )
    ''');
  }

  // Fechar o banco
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
