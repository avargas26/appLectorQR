import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrreaderappdos/src/models/scan_model.dart';
export 'package:qrreaderappdos/src/models/scan_model.dart';

class DBProvider {
  static Database _database;
  //CONSTRUNCTOR PRIVADO ESTO ES PATRON DE DISEÑO SINGLETON
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initDB();
    }

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Scans('
          'id INTEGER PRIMARY KEY,'
          'tipo TEXT,'
          'valor TEXT'
          ')');
    });
  }

  //crear registro en la db
  /*
  ESTA ES UNA VERSION DE COMO GUARDAR ESTA ES A LA ANTIGUAAAA°!!!!
  nuevoScanRaw(ScanModel nuevoScan) async {
    final db = await database;

    final res = await db.rawInsert("INSERT Into Scans (id, tipo, valor)"
        "VALUES (${nuevoScan.id}, '${nuevoScan.tipo}', '${nuevoScan.valor}')");
    return res;
  }
  */
  nuevoScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.insert('Scans', nuevoScan.toJson());
    return res;
  }

  //SELECT OBTERNER INFORMACION
  Future<ScanModel> getScanId(int id) async {
    final db = await database;
    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getTodosScans() async {
    final db = await database;
    final res = await db.query('Scans');
    List<ScanModel> list =
        res.isNotEmpty ? res.map((c) => ScanModel.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<ScanModel>> getScansPorTipo(String tipo) async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$tipo'");
    List<ScanModel> list =
        res.isNotEmpty ? res.map((c) => ScanModel.fromJson(c)).toList() : [];

    return list;
  }

  //actualizar registros
  Future<int> updScan(ScanModel nuevoScan) async {
    final db = await database;
    final res = await db.update('Scans', nuevoScan.toJson(),
        where: 'id = ?', whereArgs: [nuevoScan.id]);
    return res;
  }

  //borrar registros
  Future<int> deleteScan(int id) async {
    final db = await database;
    final res = await db.delete('Scans', where: 'id=?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAll() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Scans');
    return res;
  }
}
