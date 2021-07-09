import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OpenGMap extends StatefulWidget {
  const OpenGMap({Key key}) : super(key: key);

  @override
  _OpenGMapState createState() => _OpenGMapState();
}

class _OpenGMapState extends State<OpenGMap> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Maps Sample App'),
            backgroundColor: Colors.green[700],
          ),
          body: Stack(
            children: <Widget>[
              GoogleMap(initialCameraPosition: CameraPosition(target:
              LatLng(-33.870840,151.206286),
                  zoom: 12)
              )
            ],
          )
      ),
    );
  }
}
