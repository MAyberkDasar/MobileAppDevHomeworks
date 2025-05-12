import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const Widget1());
}

class Widget1 extends StatelessWidget {
  const Widget1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.blue,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Mobil Programlama Ödev 2",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
                Widget2(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Widget2 extends StatefulWidget {
  const Widget2({super.key});

  @override
  State<Widget2> createState() => _Widget2State();
}

class _Widget2State extends State<Widget2> {
  double fontBuyuklugu = 20.0;
  int fontIndex = 0;
  List<String> fontlar = [
    "Roboto",
    "Oswald",
    "Montserrat",
    "Caveat",
    "Anton",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Mehmet Ayberk DAŞAR",
          style: TextStyle(
            fontSize: fontBuyuklugu,
            color: Colors.white,
            fontFamily: fontlar[fontIndex],
          ),
        ),
        SizedBox(
          height: 100,
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              fontBuyuklugu++;
              print(fontBuyuklugu);
            });
          },
          child: Text(
            "Buton 1",
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              fontBuyuklugu--;
              print(fontBuyuklugu);
            });
          },
          child: Text(
            "Buton 2",
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              fontIndex = Random().nextInt(5);
              print(fontIndex);
            });
          },
          child: Text(
            "Buton 3",
          ),
        ),
      ],
    );
  }
}
