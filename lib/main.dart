import 'package:flutter/material.dart';
import 'package:pocketai_flutter/AI_Chat.dart';
import 'package:pocketai_flutter/PictureGeneration.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/chat',
    routes: {
      '/chat': (context) => AI_Chat(),
      '/image': (context) => PictureGeneration(),
    },
  ));
}

