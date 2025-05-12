import 'package:flutter/material.dart';
import 'package:odev_4/kelime_tespit.dart';

class TanitimEkrani extends StatefulWidget {
  const TanitimEkrani({super.key});

  @override
  State<TanitimEkrani> createState() => _TanitimEkraniState();
}

class _TanitimEkraniState extends State<TanitimEkrani> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Kelime Bulucu",
              style: TextStyle(fontSize: 30),
            ),
            Text(
              "Başlamak için butona tıklayınız",
              style: TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              child: Text("BAŞLA"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KelimeTespit(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
