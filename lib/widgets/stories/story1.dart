import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import '../../home_screen.dart';
import 'functions.dart';

class MyStory1 extends StatefulWidget {
  late int markerId;
  late int userId;
  MyStory1(int userId, int markerId) {
    this.userId = userId;
    this.markerId = markerId;
  }

  @override
  State<MyStory1> createState() => _MyStory1State();
}

class _MyStory1State extends State<MyStory1> {
  late int markerId;
  late int userId;

  @override
  @override
  Widget build(BuildContext context) {
    setState(() {
      markerId = widget.markerId;
      userId = widget.userId;
    });

    return Padding(
      padding: EdgeInsets.only(top: 100, left: 20, right: 20),
      child: Container(
        color: Colors.blueGrey.withOpacity(0.1),
        child: InkWell(
          child: Container(
            height: 700,
            padding: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      "https://i01.sozcucdn.com/wp-content/uploads/2016/09/mustafa-kemal-ataturk.jpg",
                    ),
                  ),
                  contentPadding: EdgeInsets.all(0),
                  title: Text(
                    "bgr",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Text(
                    "01/06/23",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 11,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    height: 30,
                    width: 200,
                    child: Text("Bakkal"),
                  ),
                ),
                Image.network(
                  "https://images.assetsdelivery.com/compings_v2/yehorlisnyi/yehorlisnyi2104/yehorlisnyi210400016.jpg",
                  height: 170,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        height: 30,
                        width: 50,
                      ),
                      FutureBuilder<List<dynamic>>(
                        future: fetchComments(markerId),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<dynamic>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('No Comments Found',
                                textScaleFactor: 1.5);
                          } else {
                            print("buraya girdik");
                            print(markerId);
                            List? _comments = snapshot.data;
                            return Column(
                              children: [
                                SizedBox(
                                  child: Text(
                                    'Comments',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _comments?.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    bool matchId = int.parse(
                                            _comments![index]['user_id']) ==
                                        userId;
                                    return FutureBuilder<String>(
                                      future: fetchUserName(int.parse(
                                          _comments![index]['user_id'])),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String> snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return ListTile(
                                            title: Text(
                                              _comments![index]
                                                  ['comment_content'],
                                            ),
                                            subtitle:
                                                Text('Loading user name...'),
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
                                          String userName = snapshot.data!;
                                          return ListTile(
                                            leading: Container(
                                              height: 30,
                                              width: 40,
                                              child: GestureDetector(
                                                child: FutureBuilder<bool>(
                                                  future: fetchLikeSituation(
                                                      userId,
                                                      int.parse(
                                                          _comments![index]
                                                              ['comment_id'])),
                                                  builder: (context, snapshot) {
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
                                                      final bool isLiked =
                                                          snapshot.data ??
                                                              false;

                                                      return FutureBuilder<int>(
                                                        future: fetchLikeCount(
                                                            _comments![index]
                                                                ['comment_id']),
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
                                                              isLiked: isLiked,
                                                              onTap:
                                                                  (isLiked) async {
                                                                if (isLiked) {
                                                                  await sendLikeStatus(
                                                                    userId,
                                                                    int.parse(_comments![
                                                                            index]
                                                                        [
                                                                        'comment_id']),
                                                                    0,
                                                                  );
                                                                } else {
                                                                  await sendLikeStatus(
                                                                    userId,
                                                                    int.parse(_comments![
                                                                            index]
                                                                        [
                                                                        'comment_id']),
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
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            shape: BoxShape
                                                                .rectangle,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                            border: Border.all(
                                                              //color: Colors.black,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          child: FutureBuilder<
                                                              List<
                                                                  Map<String,
                                                                      dynamic>>>(
                                                            future: fetchLikedUsers(
                                                                _comments![
                                                                        index][
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

                                                                return Container(
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 15),
                                                                        child:
                                                                            SizedBox(
                                                                          child:
                                                                              Text(
                                                                            'Beğenenler',
                                                                            style:
                                                                                TextStyle(fontSize: 20),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      ListView
                                                                          .builder(
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount:
                                                                            userList.length,
                                                                        itemBuilder:
                                                                            (BuildContext context,
                                                                                int index) {
                                                                          final user =
                                                                              userList[index];
                                                                          return ListTile(
                                                                            title:
                                                                                Text(
                                                                              user['user_name'],
                                                                              style: TextStyle(fontSize: 22),
                                                                            ),
                                                                            subtitle:
                                                                                Text(
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
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            title: Text(_comments![index]
                                                ['comment_content']),
                                            subtitle: Text(userName),
                                            trailing: matchId
                                                ? SizedBox(
                                                    width: 48.0,
                                                    child: IconButton(
                                                      icon: Icon(Icons.delete),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  )
                                                : SizedBox(),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
