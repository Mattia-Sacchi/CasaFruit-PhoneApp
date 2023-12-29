import 'package:flutter/material.dart';
import 'screens/MyHomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Casa Fruit',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: MyHomePage(title: 'Casa Fruit', key: null,),
    );
  }
}

