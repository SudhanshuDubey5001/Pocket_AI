import 'dart:convert';
import 'package:http/http.dart';
import 'package:pocketai_flutter/Constants.dart';
import 'package:pocketai_flutter/Messages.dart';

class Call_OpenAI_API {
  //method to get AI response from OpenAI by taking query
  Future<Messages> getAI_Response(String query) async {
    try {
      Response response = await post(Uri.parse(Constants.baseURL),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': Constants.API_KEY
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": [
              {"role": "user", "content": query}
            ],
            "temperature": 0.7
          }));

      // print('Response : ' + response.body);

      //decode the response
      Map data = jsonDecode(response.body);
      if (data['choices'] != null) {
        List choices = data['choices'];
        Map choice0 = choices[0];
        Map message = choice0['message'];

        //return the response
        return Messages(message: message['content'], type: 'AI');
      } else {
        Map error = data['error'];
        print("Error occured: " + error['message']);
        return Messages(message: "Server is too busy!! Sorry :)", type: 'error');
      }
    } catch (e) {
      return Messages(message: "Error: "+ e.toString(), type: 'error');
    }
  }
}
