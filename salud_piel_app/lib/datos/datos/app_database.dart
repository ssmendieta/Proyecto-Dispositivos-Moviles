import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

DatabaseFactory _resolveFactory() {
  if (kIsWeb) {
    return databaseFactoryFfiWeb;
  }
  return databaseFactoryFfi;
}

final DatabaseFactory _factory = _resolveFactory();

class AppDatabase {
  static final AppDatabase _instancia = AppDatabase._();
  factory AppDatabase() => _instancia;
  AppDatabase._();

  Database? _db;
  Database get db => _db!;

  Future<void> inicializar() async {
    final dbPath = await _factory.getDatabasesPath();
    final path = join(dbPath, 'salud_piel.db');

    _db = await _factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE usuarios (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              username TEXT NOT NULL,
              email TEXT UNIQUE NOT NULL,
              password_hash TEXT NOT NULL,
              fecha_creacion TEXT NOT NULL
            )
          ''');
          await _crearTablasRestantes(db);
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute('ALTER TABLE usuarios ADD COLUMN email TEXT');
            await db.execute('UPDATE usuarios SET email = username WHERE email IS NULL');
          }
        },
      ),
    );
  }

  Future<void> _crearTablasRestantes(Database db) async {
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
        marca TEXT,
        categoria TEXT,
        compatibilidad TEXT,
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
  }
}
