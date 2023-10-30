import 'package:flutter/material.dart';

class AsynchronousProgramming extends StatelessWidget {
  const AsynchronousProgramming({super.key});

  Future getDataViaFuture() async{
    while(true){
      await Future.delayed(const Duration(seconds: 1,),);
      final date = DateTime.now();
      return '${date.hour}:${date.minute}:${date.second} From FutureBuilder' ;
    }
  }

  Stream getDataViaStream() async*{
    while(true){
      await Future.delayed(const Duration(seconds: 1,),);
      final date = DateTime.now();
      yield '${date.hour}:${date.minute}:${date.second} From StreamBuilder' ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asynchronous Programming'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FutureBuilder(
              future: getDataViaFuture(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return CircularProgressIndicator();
                }
                else if(snapshot.hasError){
                  return Text("Error is : ${snapshot.error}");
                }
                else{
                  return Text("${snapshot.data}");
                }
              },
            ),
            StreamBuilder(
              stream: getDataViaStream(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error is : ${snapshot.error}");
                } else {
                  return Text("${snapshot.data}");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
