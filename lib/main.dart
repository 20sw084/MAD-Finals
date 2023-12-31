import 'package:finals_practice/firebase_example.dart';
import 'package:finals_practice/current_location.dart';
import 'package:finals_practice/google_maps.dart';
import 'package:finals_practice/provider_exmple.dart';
import 'package:finals_practice/rest_apis.dart';
import 'package:finals_practice/shared_preferences_code.dart';
import 'package:finals_practice/sqflite_example.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return TodoNotifier();
          },
        ),
      ],
      child: const Mypp(),
    ),
  );
}

class Mypp extends StatelessWidget {
  const Mypp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CloudFirestoreExample(),
    );
  }
}
