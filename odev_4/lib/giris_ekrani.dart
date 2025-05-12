import 'package:flutter/material.dart';
import 'package:odev_4/tanitim_ekrani.dart';

class GirisEkrani extends StatefulWidget {
  const GirisEkrani({super.key});

  @override
  State<GirisEkrani> createState() => _GirisEkraniState();
}

class _GirisEkraniState extends State<GirisEkrani> {
  TextEditingController tf = TextEditingController();
  TextEditingController tf2 = TextEditingController();
  String kullaniciAdi = "ayberk";
  int sifre = 123;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giriş Ekranı"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: tf,
                decoration: InputDecoration(
                  hintText: "Kullanıcı Adı",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: tf2,
                decoration: InputDecoration(
                  hintText: "Şifre",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              child: Text("GİRİŞ YAP"),
              onPressed: () {
                if (tf.text == kullaniciAdi && tf2.text == sifre.toString()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TanitimEkrani(),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Giriş Hatası"),
                        content: Text("Kullanıcı adı veya parolanız hatalı."),
                        actions: [
                          TextButton(
                            child: Text("TEKRAR DENE"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
