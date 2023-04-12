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

  List<Marker> _markers = [];
  List<String> _comments = [];
  late Map<Marker,String> myMap;
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
  // List<Marker> _marker = [];
  // List<Marker> _list = [
  //   Marker(
  //       markerId: MarkerId('1'),
  //       position: LatLng(33.6844, 73.0479),
  //       infoWindow: InfoWindow(title: 'My Current Location')),
  //   Marker(
  //       markerId: MarkerId('1'),
  //       position: LatLng(33.738045, 73.084488),
  //       infoWindow: InfoWindow(title: 'e11 sector')),
  //   Marker(
  //       markerId: MarkerId('1'),
  //       position: LatLng(33.738045, 73.084488),
  //       infoWindow: InfoWindow(title: 'e2 sector')),
  // ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _marker.addAll(_list);
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
        child: GoogleMap(
          // MARKER OBJCET
          //
          onTap: (LatLng position) async {
            String comment = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Add Comment'),
                  content: TextField(
                    controller: textController,
                    decoration: InputDecoration(hintText: 'Enter comment'),
                  ),
                  actions: [
                    TextButton(
                      child: Text('CANCEL'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: Text('ADD'),
                      onPressed: () {
                        Navigator.of(context).pop(textController.text!);
                        textController.clear();
                      },
                    ),
                  ],
                );
              },
            );
            if (comment != null) {
              setState(() {

                _markers.add(Marker(
                  markerId: MarkerId(position.toString()),
                  position: position,
                  infoWindow: InfoWindow(title: comment),
                ));
                _comments.add(comment);
              });
            }
          },
            markers: _markers.map((Marker marker) {
              return Marker(
                markerId: marker.markerId,
                position: marker.position,
                infoWindow: marker.infoWindow,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: _comments.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(_comments[index]),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        _comments.removeAt(index);
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              },
                            ),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Add a new comment:'),
                                    content: TextField(
                                      controller: textController,
                                      decoration: InputDecoration(
                                        hintText: 'Type your comment here...',
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _comments.add(textController.text!);
                                          });
                                          // Save the new comment to the database or state

                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Save Comment'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Close the alert dialog without saving the comment
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Text('Add a New Comment'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            }).toSet(),
          initialCameraPosition: CameraPosition(
            target: LatLng(38.729210, 35.483910),
            zoom: 10,
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: FloatingActionButton(
            child: Icon(Icons.location_disabled_outlined),
            onPressed: () async {
              GoogleMapController controller = await _controller.future;
              controller
                  .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                      target: LatLng(33.738045, 73.084488),
                      //altaki konum simgesine bastığında seni o konuma götürüyor
                      zoom: 14)));
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}
/*
target: LatLng(38.729210, 35.483910),
markers: _markers.map((Marker marker) {
            return Marker(
              markerId: marker.markerId,
              position: marker.position,
              infoWindow: marker.infoWindow,
              onTap: () {
                showModalBottomSheet(
                  context: context,

                  builder: (BuildContext context) {
                    return Container(
                      height: 250,
                      child:
                      Column(
                        children: [
                          IconButton(
                              color: Colors.black,
                              onPressed: () {
                                setState(() {
                                  _markers.remove(marker);
                                });

                              },
                              icon: Icon(Icons.remove_circle_outline)),
                          Center(child: Text(marker.infoWindow.title!)),
                        ],
                      ),//
                    );
                  },
                );
              },
            );
          }).toSet(),




 */