import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesCode extends StatefulWidget {

  SharedPreferencesCode({super.key});

  @override
  State<SharedPreferencesCode> createState() => _SharedPreferencesCodeState();
}

class _SharedPreferencesCodeState extends State<SharedPreferencesCode> {
  String? someText;

  setText(String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('text',text);
  }

  Future<void> getText() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    someText = prefs.getString('text') ?? "";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getText();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController tec = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Shared Preferences"),
      ),
      body: Column(
        children: [
          Text(someText ?? "Some Text"),
          TextField(
            controller: tec,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                someText = tec.text;
                setText(someText!);
              });
            },
            child: const Text(
              "Save",
            ),
          ),
        ],
      ),
    );
  }
}