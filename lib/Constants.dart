import 'package:flutter/material.dart';

class Constants {

  static String baseURL = "https://api.openai.com/v1/chat/completions";
  static String API_KEY = "Bearer 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";

  static Color setThemeColor() {
    return Colors.white;
  }

  static Color setAIResponseColor() {
    return Colors.purple.shade900;
    // Colors.purpleBea
  }

  static Color setUserQueryColor() {
    return Colors.black;
  }
}
