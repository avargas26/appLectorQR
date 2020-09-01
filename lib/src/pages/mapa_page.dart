import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreaderappdos/src/models/scan_model.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final map = new MapController();

  String tipoMapa = 'streets-v11';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.my_location),
              onPressed: () {
                map.move(scan.getLatLng(), 10);
              })
        ],
      ),
      body: _crearFlutterMap(scan),
      floatingActionButton: _crearBotonFlotante(context, scan),
    );
  }

  Widget _crearBotonFlotante(BuildContext context, ScanModel scan) {
    return FloatingActionButton(
        child: Icon(Icons.repeat),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          print(tipoMapa);
          if (tipoMapa == 'streets-v11') {
            tipoMapa = 'dark-v10';
          } else if (tipoMapa == 'dark-v10') {
            tipoMapa = 'light-v10';
          } else {
            tipoMapa = 'streets-v11';
          }
          setState(() {});
          //movimiento #1 al maximo de zoom
          map.move(scan.getLatLng(), 30);

          //Regreso al Zoom Deseado después de unos Milisegundos
          Future.delayed(Duration(milliseconds: 50), () {
            map.move(scan.getLatLng(), 10);
          });
        });
  }

  Widget _crearFlutterMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(center: scan.getLatLng(), zoom: 10),
      layers: [_crearMapa(), _crearMarcadores(scan)],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
        urlTemplate:
            'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1IjoiYW5kcmVzbXVzdGFpbmUiLCJhIjoiY2tla2RveGVhMDA3NTJxcWQ1cXpoMWJmdyJ9.CXBbV2d1jG3XkjFqvv-SCA',
          'id': 'mapbox/$tipoMapa'
          //streets darr, light, outtdorrs, satellite
        });
  }

  _crearMarcadores(ScanModel scan) {
    return MarkerLayerOptions(markers: <Marker>[
      Marker(
          width: 120.0,
          height: 120.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
                child: Icon(Icons.location_on,
                    size: 45.0, color: Theme.of(context).primaryColor),
              ))
    ]);
  }
}
