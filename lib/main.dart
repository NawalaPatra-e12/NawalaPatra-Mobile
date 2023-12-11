import 'package:flutter/material.dart';
import 'package:nawalapatra_mobile/menu.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 6, 22, 38)),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

