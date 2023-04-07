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
        infoWindow: InfoWindow(title: 'My Current Location')),
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(33.738045, 73.084488),
        infoWindow: InfoWindow(title: 'e11 sector')),
    Marker(
        markerId: MarkerId('1'),
        position: LatLng(33.738045, 73.084488),
        infoWindow: InfoWindow(title: 'e2 sector')),
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
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Color(0xFF5291f4),
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://i01.sozcucdn.com/wp-content/uploads/2016/09/mustafa-kemal-ataturk.jpg'),
            ),
          ),
        ),
        title: const Text(
          'Name',
          style: TextStyle(
            fontFamily: 'Nunito',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Container(
            height: 100,
            width: 100,
            color: Colors.white,
            alignment: Alignment.center,
            child: const Text('Membership Rank'),
            margin: EdgeInsets.only(bottom: 5),
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30.0),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFe8eaed),
                Color(0xFF5291f4),
              ],
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30.0),
          ),
        ),
      ),
      body: SafeArea(
        child: GoogleMap(initialCameraPosition: _kGooglePlex,
          markers: Set<Marker>.of(_marker),
          mapType: MapType.normal,
          // myLocationEnabled: true,
          //compassEnabled: false,
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          },

        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.location_disabled_outlined),
        onPressed: () async{
          GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(33.738045, 73.084488),//altaki konum simgesine bastığında seni o konuma götürüyor
                  zoom: 14
              )
          ));
          setState(() {

          });
        },
      ),

    );
  }
}
