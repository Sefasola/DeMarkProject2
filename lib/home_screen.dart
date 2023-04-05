import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = const CameraPosition(
      target: LatLng(33.6844, 73.0479),
    zoom: 14,
      );

  List<Marker> _marker = [];
  List<Marker> _list = [
    Marker(
        markerId: MarkerId('1'),
    position: LatLng(33.6844, 73.0479),
      infoWindow: InfoWindow(
        title: 'My Current Location'
      )
    ),
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(33.738045, 73.084488),
        infoWindow: InfoWindow(
            title: 'e11 sector'
        )
    ),
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(33.738045, 73.084488),
        infoWindow: InfoWindow(
            title: 'e2 sector'
        )
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _marker.addAll(_list);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(initialCameraPosition: _kGooglePlex,
        markers: Set<Marker>.of(_marker),
        mapType: MapType.normal,
       // myLocationEnabled: true,
        //compassEnabled: false,
        onMapCreated: (GoogleMapController controller){
        _controller.complete(controller);
        },
        
      ),
    );
  }
}
