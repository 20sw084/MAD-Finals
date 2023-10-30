import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestApis extends StatefulWidget {
  @override
  State<RestApis> createState() => _RestApisState();
}

class _RestApisState extends State<RestApis> {
  List<dynamic> imgdt = [];
  bool loading = false;

  Future getData() async {
    setState(() => loading = true);
    var response = await http.get(
      Uri.parse(
        "https://jsonplaceholder.typicode.com/photos",
      ),
    );
    setState(() {
      imgdt = json.decode(response.body);
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("REST api's"),
      ),
      // https://jsonplaceholder.typicode.com/photos
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: imgdt.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 300,
                  width: 300,
                  child: Image.network(
                    imgdt[index]['url'],
                  ),
                );
              },
            ),
    );
  }
}

class ImageData {
  int? albumId;
  int? id;
  String? title;
  String? url;
  String? thumbnailUrl;
  // {
  // "albumId": 1,
  // "id": 1,
  // "title": "accusamus beatae ad facilis cum similique qui sunt",
  // "url": "https://via.placeholder.com/600/92c952",
  // "thumbnailUrl": "https://via.placeholder.com/150/92c952"
  // },
}
