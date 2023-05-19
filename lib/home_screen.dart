import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import './login/login.dart';
import 'package:http/http.dart' as http;
import 'login/loginProvider.dart';
import 'like/likeFunction.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String urlMain = '192.168.1.194';
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(33.6844, 73.0479),
    zoom: 14,
  );

  // Post fonksiyonu

  List<Marker> _markers = [];
  List<String> _comments = [];
  late Map<Marker, String> myMap;
  late Future<List<Marker>> futuremarker;
  final textController = TextEditingController();

//fetching the data from comments specialized to the selected marker
  Future<List<dynamic>> fetchComments(int markerId) async {
    final response = await http.post(
        Uri.parse('http://${urlMain}/project/getCommentsForMarker.php'),
        body: {
          'marker_id': markerId.toString(),
        });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to retrieve comments');
    }
  }

  //Post comment
  Future<void> postComment(
      int markerId, int userId, String commentContent) async {
    final response = await http
        .post(Uri.parse('http://${urlMain}/project/postComment.php'), body: {
      'marker_id': markerId.toString(),
      'user_id': userId.toString(),
      'comment_content': commentContent,
    });
    if (response.statusCode == 200) {
      // Parse the response as JSON and return the comment ID
      final data = json.decode(response.body);
      return data['comment_id'];
    } else {
      // Handle the error
      throw Exception('Failed to post comment: ${response.statusCode}');
    }
  }

//iteration-2 notes
//--------------------
//will be re-arranged to take user_id as input also (DONE)
//include the comments to access user_id
//implement a filter to search category for places
//3 weeks (05.05.23)

  Future postMarker(
      double posX, double posY, String title, String message) async {
    final response = await http
        .post(Uri.parse('http://${urlMain}/project/postMarker.php'), body: {
      'position_x': posX.toString(),
      'position_y': posY.toString(),
      'title': title,
      'message': message,
    });

    if (response.statusCode == 200) {
      // Marker was posted successfully, parse the response
      final data = jsonDecode(response.body);
      final markerId = data['marker_id'];
      final marker = Marker(
        markerId: MarkerId(markerId.toString()),
        position: LatLng(posX, posY),
        infoWindow: InfoWindow(title: title, snippet: message),
      );
      return marker;
    } else {
      // Marker posting failed
      throw Exception('Failed to post marker: ${response.body}');
    }
  }

  //Bütün markerları alma fonksiyonu

  Future<List<Marker>> getAllMarkers() async {
    final response = await http
        .get(Uri.parse('http://${urlMain}/project/getAllMarkers.php'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;

      try {
        final List<Marker> markers = data
            .map((markerJson) => Marker(
                  markerId: MarkerId(markerJson["marker_id"].toString()),
                  position: LatLng(double.parse(markerJson["position_x"]),
                      double.parse(markerJson["position_y"])),
                  infoWindow: InfoWindow(
                      title: markerJson['title'],
                      snippet: markerJson['message']),
                ))
            .toList();
        return markers;
      } catch (e) {
        print("An error occurred while mapping marker data: $e");
        // You can choose to return an empty list or handle the error accordingly
        // For example, you can throw an exception to propagate the error to the caller
        // throw Exception("An error occurred while mapping marker data: $e");
        return _markers;
      }
    } else {
      throw Exception('Failed to get markers: ${response.body}');
    }
  }

// post comment Fonksyonu

  // markerları futurdan kurtarma fonksyonu

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
    //super.initState();
    futuremarker = getAllMarkers();
  }

  @override
  Widget build(BuildContext context) {
    Future<String> fetchUserName(int userId) async {
      final url = 'http://${urlMain}/project/userNameBringer.php';
      final response = await http.post(
        Uri.parse(url),
        body: {
          'userId': userId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['userName'];
      } else {
        throw Exception('Failed to fetch user');
      }
    }

    late bool matchId;
    bool islogged = Provider.of<LoginStatus>(context, listen: false).isLoggedIn;
    String userLevel = Provider.of<LoginStatus>(context, listen: false).level;
    int userId = Provider.of<LoginStatus>(context, listen: false).userId;
    String userName = Provider.of<LoginStatus>(context, listen: false).userName;

    return MultiProvider(
      providers: [
        Provider<LoginStatus>(
          create: (_) => LoginStatus(),
        ),
      ],
      child: MaterialApp(
          home: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(90.0),
            child:
                Consumer<LoginStatus>(builder: (context, loginStatus, child) {
              if (islogged) {
                return AppBar(
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
                  title: Text(
                    userName,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                    ),
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(
                      onPressed: () {
                        islogged = !islogged;
                        (context as Element).reassemble();
                      },
                      icon: const Icon(Icons.login_outlined),
                    ),
                    IconButton(
                      onPressed: () {
                        fetchLikeSituation(17, 1);
                      },
                      icon: const Icon(Icons.menu),
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(20.0),
                    child: Text(
                      userLevel,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                      textScaleFactor: 1.2,
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
                );
              } else {
                return AppBar(
                  centerTitle: true,
                  backgroundColor: Color(0xFFe8eaed),
                  title: Center(
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginView()),
                          );
                        },
                        child: Text("Click to Login")),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30.0),
                    ),
                  ),
                );
              }
            })),
        body: SafeArea(
          child: FutureBuilder<List<Marker>>(
              future: futuremarker,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _markers.addAll(snapshot.data!);
                } else {}
                return GoogleMap(
                  // MARKER OBJCET
                  //
                  onTap: (LatLng position) async {
                    String comment = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Add Marker'),
                          content: TextField(
                            controller: textController,
                            decoration:
                                InputDecoration(hintText: 'Initial comment'),
                          ),
                          actions: [
                            TextButton(
                              child: Text('CANCEL'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            TextButton(
                              child: Text('ADD'),
                              onPressed: () {
                                postMarker(
                                    position.latitude,
                                    position.longitude,
                                    textController.text,
                                    textController.text);
                                Navigator.of(context).pop(textController.text!);
                                textController.clear();
                                setState(() {
                                  futuremarker = getAllMarkers();
                                });
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  markers: _markers.map((Marker marker) {
                    return Marker(
                      markerId: marker.markerId,
                      position: marker.position,
                      infoWindow: marker.infoWindow,
                      onTap: () {
                        showModalBottomSheet(
                          elevation: 0.5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                  ),
                                  FutureBuilder<List<dynamic>>(
                                    future: fetchComments(
                                        int.parse(marker.markerId.value)),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<dynamic>> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('No Comments Found',
                                            textScaleFactor: 1.5);
                                      } else {
                                        List? _comments = snapshot.data;

                                        return ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: _comments?.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            bool matchId = int.parse(
                                                    _comments![index]
                                                        ['user_id']) ==
                                                userId;
                                            return FutureBuilder<String>(
                                              future: fetchUserName(int.parse(
                                                  _comments![index]
                                                      ['user_id'])),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<String>
                                                      snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return ListTile(
                                                    title: Text(
                                                      _comments![index]
                                                          ['comment_content'],
                                                    ),
                                                    subtitle: Text(
                                                        'Loading user name...'),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return ListTile(
                                                    title: Text(
                                                      _comments![index]
                                                          ['comment_content'],
                                                    ),
                                                    subtitle: Text(
                                                        'Failed to fetch user name'),
                                                  );
                                                } else {
                                                  String userName =
                                                      snapshot.data!;
                                                  return ListTile(
                                                    leading: Container(
                                                      height: 30,
                                                      width: 40,
                                                      child: GestureDetector(
                                                        child:
                                                            FutureBuilder<bool>(
                                                          future: fetchLikeSituation(
                                                              userId,
                                                              int.parse(_comments![
                                                                      index][
                                                                  'comment_id'])),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return CircularProgressIndicator();
                                                            } else if (snapshot
                                                                .hasError) {
                                                              return Text(
                                                                  'Error: ${snapshot.error}');
                                                            } else {
                                                              final bool
                                                                  isLiked =
                                                                  snapshot.data ??
                                                                      false;

                                                              return FutureBuilder<
                                                                  int>(
                                                                future: fetchLikeCount(
                                                                    _comments![
                                                                            index]
                                                                        [
                                                                        'comment_id']),
                                                                builder: (context,
                                                                    snapshot) {
                                                                  if (snapshot
                                                                          .connectionState ==
                                                                      ConnectionState
                                                                          .waiting) {
                                                                    return CircularProgressIndicator();
                                                                  } else if (snapshot
                                                                      .hasError) {
                                                                    return Text(
                                                                        'Error: ${snapshot.error}');
                                                                  } else {
                                                                    final int
                                                                        likeCount =
                                                                        snapshot.data ??
                                                                            0;

                                                                    return LikeButton(
                                                                      isLiked:
                                                                          isLiked,
                                                                      onTap:
                                                                          (isLiked) async {
                                                                        if (isLiked) {
                                                                          await sendLikeStatus(
                                                                            userId,
                                                                            int.parse(_comments![index]['comment_id']),
                                                                            0,
                                                                          );
                                                                        } else {
                                                                          await sendLikeStatus(
                                                                            userId,
                                                                            int.parse(_comments![index]['comment_id']),
                                                                            1,
                                                                          );
                                                                        }
                                                                        // Return the new liked state
                                                                        return !isLiked;
                                                                      },
                                                                      likeCount:
                                                                          likeCount,
                                                                      size: 28,
                                                                    );
                                                                  }
                                                                },
                                                              );
                                                            }
                                                          },
                                                        ),
                                                        onLongPress: () {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return Dialog(
                                                                child: FutureBuilder<
                                                                    List<
                                                                        Map<String,
                                                                            dynamic>>>(
                                                                  future: fetchLikedUsers(
                                                                      _comments![
                                                                              index]
                                                                          [
                                                                          'comment_id']), // Replace with your actual fetchLikedUsers function
                                                                  builder: (context,
                                                                      snapshot) {
                                                                    if (snapshot
                                                                            .connectionState ==
                                                                        ConnectionState
                                                                            .waiting) {
                                                                      return Center(
                                                                          child:
                                                                              CircularProgressIndicator());
                                                                    } else if (snapshot
                                                                        .hasError) {
                                                                      return Text(
                                                                          'Error: ${snapshot.error}');
                                                                    } else {
                                                                      final userList =
                                                                          snapshot.data ??
                                                                              [];

                                                                      return Expanded(
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 15),
                                                                              child: SizedBox(
                                                                                child: Text(
                                                                                  'Beğenenler',
                                                                                  style: TextStyle(fontSize: 20),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            ListView.builder(
                                                                              shrinkWrap: true,
                                                                              itemCount: userList.length,
                                                                              itemBuilder: (BuildContext context, int index) {
                                                                                final user = userList[index];
                                                                                return ListTile(
                                                                                  title: Text(
                                                                                    user['user_name'],
                                                                                    style: TextStyle(fontSize: 22),
                                                                                  ),
                                                                                  subtitle: Text(
                                                                                    user['level'],
                                                                                    style: TextStyle(fontSize: 13),
                                                                                  ),
                                                                                  // Add other widget components as needed
                                                                                );
                                                                              },
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    title: Text(_comments![
                                                            index]
                                                        ['comment_content']),
                                                    subtitle: Text(userName),
                                                    trailing: matchId
                                                        ? SizedBox(
                                                            width: 48.0,
                                                            child: IconButton(
                                                              icon: Icon(
                                                                  Icons.delete),
                                                              onPressed: () {
                                                                setState(() {
                                                                  _comments!
                                                                      .removeAt(
                                                                          index);
                                                                });
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                          )
                                                        : SizedBox(),
                                                  );
                                                }
                                              },
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (islogged) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Add a new comment:'),
                                            content: TextField(
                                              controller: textController,
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Type your comment here...',
                                              ),
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _comments.add(
                                                        textController.text!);
                                                  });
                                                  // Save the new comment to the database or state
                                                  postComment(
                                                      int.parse(marker
                                                          .markerId.value),
                                                      userId,
                                                      textController.text);

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
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: ((context) => AlertDialog(
                                                  title: Text(
                                                      'You Need be Logged In to Comment'),
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const LoginView()),
                                                        );
                                                        setState(() {});
                                                      },
                                                      child: Text('Login Page'),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        // Close the alert dialog without saving the comment
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Cancel'),
                                                    ),
                                                  ],
                                                )));
                                      }
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
                );
              }),
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: FloatingActionButton(
              child: Icon(Icons.location_disabled_outlined),
              onPressed: () async {
                GoogleMapController controller = await _controller.future;
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                        target: LatLng(33.738045, 73.084488),
                        //altaki konum simgesine bastığında seni o konuma götürüyor
                        zoom: 14)));
                setState(() {});
              },
            ),
          ),
        ),
      )),
    );
  }
}
