import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/stories/story1.dart';
import '../widgets/stories/story2.dart';
import '../widgets/stories/story3.dart';
import '../widgets/storyBars.dart';

class StoryPage extends StatefulWidget {
  final int index;
  final int userId;
  final int markerId;

  StoryPage({
    Key? key,
    required this.index,
    required this.userId,
    required this.markerId,
  }) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late int currentStoryIndex;

  List<Widget> myStories = [];

  List<double> percentWatched = [];

  @override
  void initState() {
    super.initState();

    currentStoryIndex = widget.index;

    myStories = [
      MyStory1(widget.userId, widget.markerId),
      MyStory2(widget.userId, widget.markerId),
      MyStory3(widget.userId, widget.markerId),
    ];

    for (int i = 0; i < myStories.length; i++) {
      percentWatched.add(0);
    }

    _startWatching();
  }

  void _startWatching() {
    Timer.periodic(Duration(milliseconds: 110), (timer) {
      setState(() {
        if (percentWatched[currentStoryIndex] + 0.01 < 1) {
          percentWatched[currentStoryIndex] += 0.01;
        } else {
          percentWatched[currentStoryIndex] = 1;
          timer.cancel();

          if (currentStoryIndex < myStories.length - 1) {
            currentStoryIndex++;
            _startWatching();
          } else {
            Navigator.pop(context);
          }
        }
      });
    });
  }

  void _onTapDown(TapDownDetails details) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;

    if (dx < screenWidth / 2) {
      setState(() {
        if (currentStoryIndex > 0) {
          percentWatched[currentStoryIndex - 1] = 0;
          percentWatched[currentStoryIndex] = 0;
          currentStoryIndex--;
        }
      });
    } else {
      setState(() {
        if (currentStoryIndex < myStories.length - 1) {
          percentWatched[currentStoryIndex] = 1;
          currentStoryIndex++;
        } else {
          percentWatched[currentStoryIndex] = 1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _onTapDown(details),
      child: Scaffold(
        body: Stack(
          children: [
            myStories[currentStoryIndex],
            MyStoryBars(
              percentWatched: percentWatched,
            ),
          ],
        ),
      ),
    );
  }
}
