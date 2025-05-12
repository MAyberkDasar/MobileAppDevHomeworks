import 'package:flutter/material.dart';
import 'package:odev_5/bilgilerim.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Giris extends StatefulWidget {
  const Giris({super.key});

  @override
  State<Giris> createState() => _GirisState();
}

class _GirisState extends State<Giris> {
  TextEditingController kullaniciAdiController = TextEditingController();
  TextEditingController parolaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giriş Yap"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: kullaniciAdiController,
              decoration: InputDecoration(
                hintText: "Kullanıcı Adı",
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: parolaController,
              decoration: InputDecoration(
                hintText: "Şifre",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            ElevatedButton(
              child: Text("Giriş Yap"),
              onPressed: () {
                girisYap(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> kullaniciKontrolEt(String kullaniciAdi, String parola) async {
    String veritabaniYolu = await getDatabasesPath();
    String tamYol = join(veritabaniYolu, "kullanicilar.db");
    Database db = await openDatabase(tamYol);

    var bilgiler = await db.query(
      "kullanicilar",
      where: "kullaniciAdi = ? AND parola = ?",
      whereArgs: [kullaniciAdi, parola],
    );
    return bilgiler.isNotEmpty;
  }

  void girisYap(BuildContext context) async {
    String kullaniciAdi = kullaniciAdiController.text;
    String parola = parolaController.text;

    if (await kullaniciKontrolEt(kullaniciAdi, parola)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Bilgilerim(kullaniciAdi: kullaniciAdi),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Giriş Başarısız"),
            content: Text("Kullanıcı adı veya şifrenizi kontrol ediniz"),
            actions: [
              TextButton(
                child: Text("Tekrar Dene"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
