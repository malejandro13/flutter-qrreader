import 'dart:async';
import 'package:qrreaderapp/src/bloc/validator.dart';
import 'package:qrreaderapp/src/providers/db_provider.dart';

class ScansBloc with Validators {
  
  static final ScansBloc _singleton = new ScansBloc._();

  factory ScansBloc(){
    return _singleton;
  }

  ScansBloc._() {
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream => _scansController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scansStreamHttp => _scansController.stream.transform(validarHttp);

  dispose(){
    _scansController?.close();
  }

  agregarScan(ScanModel scan) async {
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();
  }

  obtenerScans() async {
    _scansController.sink.add( await DBProvider.db.getAllScans());
  }

  borrarScan(int id) async {
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  } 

  borrarScansTODOS() async {
    await DBProvider.db.deleteScanAll();
    obtenerScans();
  }

}