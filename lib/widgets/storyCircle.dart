import 'package:flutter/material.dart';

class StoryCircle extends StatelessWidget {
  final function;

  StoryCircle({this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            //color: Colors.white,
            border: Border.all(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://img.freepik.com/free-vector/start_53876-25533.jpg?w=2000'),
          ),
        ),
      ),
    );
  }
}
