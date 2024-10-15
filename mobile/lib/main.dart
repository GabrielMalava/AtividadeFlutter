import 'package:flutter/material.dart';
import 'package:mobile/screen/lista.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transações',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ListaScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
