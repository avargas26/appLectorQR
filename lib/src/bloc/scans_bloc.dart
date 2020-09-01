import 'dart:async';

import 'package:qrreaderappdos/src/bloc/validator.dart';
import 'package:qrreaderappdos/src/providers/db_provider.dart';

class ScansBloc with Validators {
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    //obtener scans de la base de datos
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();
  //geolocation
  Stream<List<ScanModel>> get scansStream =>
      _scansController.stream.transform(validarGeo);
  //http
  Stream<List<ScanModel>> get scansStreamHttp =>
      _scansController.stream.transform(validarHttp);

  dispose() {
    _scansController?.close();
  }

  obtenerScans() async {
    _scansController.sink.add(await DBProvider.db.getTodosScans());
  }

  agregarScan(ScanModel scan) async {
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();
  }

  borrarScan(int id) async {
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarScanTODOS() async {
    await DBProvider.db.deleteAll();
    obtenerScans();
  }
}
