import 'package:flutter/material.dart';
import 'package:odev_5/giris.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Kayit extends StatefulWidget {
  @override
  State<Kayit> createState() => _KayitState();
}

class _KayitState extends State<Kayit> {
  TextEditingController kullaniciAdiController = TextEditingController();
  TextEditingController parolaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kayıt Ol"),
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
                hintText: "Parola",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            ElevatedButton(
              child: Text("Kayıt Ol"),
              onPressed: () {
                kayitOl(context, kullaniciAdiController.text,
                    parolaController.text);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<Database> veritabaniOlustur() async {
    String veritabaniYolu = await getDatabasesPath();
    String tamYol = join(veritabaniYolu, "kullanicilar.db");
    return await openDatabase(
      tamYol,
      version: 1,
      onCreate: (db, version) async {
        return db.execute("""
          CREATE TABLE kullanicilar(
            id INTEGER PRIMARY KEY, 
            kullaniciAdi TEXT,
            parola TEXT,
            ad TEXT,
            soyad TEXT,
            cinsiyet TEXT,
            hobiler TEXT,
            dogumTarihi TEXT
          )
        """);
      },
    );
  }

  Future<void> kayitOl(
      BuildContext context, String kullaniciAdi, String parola) async {
    Database db = await veritabaniOlustur();

    await db.insert(
      "kullanicilar",
      {"kullaniciAdi": kullaniciAdi, "parola": parola},
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Kayıt Başarılı"),
          content: Text("${kullaniciAdi} başarıyla kaydedildi."),
          actions: [
            TextButton(
              child: Text("Geri"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Giriş Yap"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Giris(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
