import 'package:flutter/material.dart';
import 'package:odev_6/kayit_ekrani.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gelir-Gider Takip Uygulaması',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: KayitEkrani(),
    );
  }
}
