import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase _instancia = AppDatabase._();
  factory AppDatabase() => _instancia;
  AppDatabase._();

  Database? _db;
  Database get db => _db!;

  Future<void> inicializar() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'salud_piel.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            password_hash TEXT NOT NULL,
            fecha_creacion TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE diagnosticos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            imagen_path TEXT NOT NULL,
            condicion TEXT NOT NULL,
            confianza REAL NOT NULL,
            fecha TEXT NOT NULL,
            descripcion TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE diagnosticos_productos (
            diagnostico_id INTEGER NOT NULL,
            producto_id INTEGER NOT NULL,
            FOREIGN KEY (diagnostico_id) REFERENCES diagnosticos(id),
            FOREIGN KEY (producto_id) REFERENCES productos(id)
          )
        ''');

        await db.execute('''
          CREATE TABLE productos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            descripcion TEXT,
            ingredientes TEXT,
            tipo_piel TEXT,
            condicion TEXT,
            imagen_path TEXT,
            como_usar TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE rutinas (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nombre TEXT NOT NULL,
            momento TEXT NOT NULL,
            fecha_creacion TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE rutinas_productos (
            rutina_id INTEGER NOT NULL,
            producto_id INTEGER NOT NULL,
            orden INTEGER NOT NULL DEFAULT 0,
            completado INTEGER NOT NULL DEFAULT 0,
            FOREIGN KEY (rutina_id) REFERENCES rutinas(id),
            FOREIGN KEY (producto_id) REFERENCES productos(id)
          )
        ''');
      },
    );
  }
}
