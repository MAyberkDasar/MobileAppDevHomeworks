import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var butonYazisi = "IŞIKLARI AÇ";
  List<bool> lambaDurumlari = [false, false, false, false];
  void rastgeleBirLambaAc() {
    setState(() {
      int randomIndex = Random().nextInt(4);
      lambaDurumlari[randomIndex] = true;
      butonYazisi = "IŞIKLARI KAPAT";
    });
  }

  void rastgeleIkiLambaAc() {
    setState(() {
      int randomIndex = Random().nextInt(4);
      lambaDurumlari[randomIndex] = true;
      int randomIndex2 = Random().nextInt(4);
      lambaDurumlari[randomIndex2] = true;
      butonYazisi = "IŞIKLARI KAPAT";
    });
  }

  void lambalariAc() {
    setState(() {
      lambaDurumlari = [true, true, true, true];
      butonYazisi = "IŞIKLARI KAPAT";
    });
  }

  void lambalariKapat() {
    setState(() {
      lambaDurumlari = [false, false, false, false];
      butonYazisi = "IŞIKLARI AÇ";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: lambaDurumlari[0] ? Colors.yellow : Colors.black,
                ),
                Icon(
                  Icons.lightbulb_outline,
                  color: lambaDurumlari[1] ? Colors.yellow : Colors.black,
                ),
              ],
            ),
            GestureDetector(
              onDoubleTap: () {
                rastgeleIkiLambaAc();
              },
              onLongPress: () {
                lambalariAc();
              },
              child: ElevatedButton(
                onPressed: () {
                  if (butonYazisi == "IŞIKLARI AÇ") {
                    rastgeleBirLambaAc();
                  } else {
                    lambalariKapat();
                  }
                },
                child: Text(butonYazisi),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: lambaDurumlari[2] ? Colors.yellow : Colors.black,
                ),
                Icon(
                  Icons.lightbulb_outline,
                  color: lambaDurumlari[3] ? Colors.yellow : Colors.black,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
