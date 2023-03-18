import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pocketai_flutter/Constants.dart';
import 'package:pocketai_flutter/Messages.dart';
import 'package:pocketai_flutter/services/CallOpenAI_API.dart';

class AI_Chat extends StatefulWidget {
  const AI_Chat({Key? key}) : super(key: key);

  @override
  State<AI_Chat> createState() => _AI_ChatState();
}

class _AI_ChatState extends State<AI_Chat> {
  List AI_responsesList = [];
  Call_OpenAI_API cai = Call_OpenAI_API();
  final queryTextController = TextEditingController();
  final APIkeycontroller = TextEditingController();
  bool restrictButton = true;
  Color tileColor = Constants.setUserQueryColor();
  int i = 0;

  bool gotkey = false;

  List<Messages> msg = [];

  double screenheight =0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void fetchResponse(String query) async {
    Messages m = await cai.getAI_Response(query);
    msg.add(m);
    print("Response received --> " + m.getMessage());
    restrictButton = true;
    setState(() {
      tileColor = Constants.setAIResponseColor();
      AI_responsesList.add(msg[i].getMessage());
    });
    i++;
  }

  void dismissKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    queryTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    screenheight = MediaQuery.of(context).size.height;
    print("height = "+screenheight.toString());

    return GestureDetector(
      onTap: () {
        dismissKeyboard();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 5.0,
          title: const Text(
            "Chat AI",
            style: TextStyle(color: Colors.black, letterSpacing: 2.0),
          ),
          centerTitle: true,
          backgroundColor: Constants.setThemeColor(),
        ),
        body: Stack(
          children: [
            ListView.builder(
                itemCount: AI_responsesList.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Align(
                      alignment: (msg[index].getType() == 'AI'
                          ? Alignment.bottomLeft
                          : Alignment.bottomRight),
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (msg[index].getType() == 'AI'
                              ? Constants.setAIResponseColor()
                              : Constants.setUserQueryColor()),
                        ),
                        child: Text(
                          AI_responsesList[index],
                          style: TextStyle(
                              fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 10.0),
                    child: Row(children: [
                      Flexible(
                        child: TextField(
                            controller: queryTextController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Enter query here",
                            )),
                        flex: 1,
                      ),
                      IconButton(
                          onPressed: () {
                            dismissKeyboard();
                            if (restrictButton) {
                              restrictButton = false;
                              msg.add(Messages(
                                  message: queryTextController.text, type: 'user'));
                              setState(() {
                                tileColor = Constants.setUserQueryColor();
                                AI_responsesList.add(queryTextController.text);
                              });
                              i++;
                              if (gotkey) {
                                fetchResponse(queryTextController.text);
                              } else {
                                ApiKeyDialog(context);
                                restrictButton = true;
                                gotkey = true;
                              }
                            }
                            queryTextController.value = TextEditingValue(text: "");
                          },
                          icon: Icon(Icons.send))
                    ]),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // //dialog box
  Future<void> ApiKeyDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter your API key'),
            content: TextField(
              controller: APIkeycontroller,
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.black,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    Constants.API_KEY = APIkeycontroller.text == ""
                        ? "Bearer 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"
                        : "Bearer " + APIkeycontroller.text;
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }
}
