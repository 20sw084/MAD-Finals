import 'package:finals_practice/provider_exmple.dart';
import 'package:finals_practice/rest_apis.dart';
import 'package:finals_practice/shared_preferences_code.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: SharedPreferencesCode(),
    );
  }
}
