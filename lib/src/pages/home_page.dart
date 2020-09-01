import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:qrreaderappdos/src/pages/dirreciones_page.dart';
import 'package:qrreaderappdos/src/pages/mapas_page.dart';
import 'package:qrreaderappdos/src/bloc/scans_bloc.dart';
import 'package:qrreaderappdos/src/models/scan_model.dart';
import 'package:qrreaderappdos/src/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('QR Scanner'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: scansBloc.borrarScanTODOS,
            )
          ],
        ),
        body: _loadPage(currentIndex),
        bottomNavigationBar: _crearNavBB(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.filter_center_focus),
          onPressed: () => _scanQR(context),
          backgroundColor: Theme.of(context).primaryColor,
        ));
  }

  Widget _crearNavBB() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('Mapas')),
        BottomNavigationBarItem(
            icon: Icon(Icons.brightness_5), title: Text('Direcciones'))
      ],
    );
  }

  _scanQR(BuildContext context) async {
    ScanResult futureString;
    //https://www.dcanje.com
    //Future String: geo:29.130419791799724,-81.04543104609378
    try {
      futureString = await BarcodeScanner.scan();
    } catch (e) {
      futureString.rawContent = e.toString();
    }
    //dynamic futureString = 'https://www.dcanje.com';

    if (futureString != null) {
      final scan = ScanModel(valor: futureString.rawContent);
      scansBloc.agregarScan(scan);

      //unicamente en ios esto para relentelizar
      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750), () {
          utils.abrirScan(context, scan);
        });
      } else {
        utils.abrirScan(context, scan);
      }
    }
  }

  Widget _loadPage(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return MapasPage();
      case 1:
        return DireccionesPage();
      default:
        return MapasPage();
    }
  }
}
