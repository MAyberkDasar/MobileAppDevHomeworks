import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TumKullanicilar extends StatefulWidget {
  const TumKullanicilar({super.key});

  @override
  State<TumKullanicilar> createState() => _TumKullanicilarState();
}

class _TumKullanicilarState extends State<TumKullanicilar> {
  List<Map<String, dynamic>> kullanicilarListesi = [];
  ScrollController scrollController = ScrollController();
  double kaydirmaMiktari = 0.0;
  List<bool> genislemeDurumlari = [];

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      setState(() {
        kaydirmaMiktari = scrollController.offset;
      });
    });
    kullanicilariYukle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kayıtlı Kullanıcılar"),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        controller: scrollController,
        itemCount: kullanicilarListesi.length,
        itemBuilder: (context, index) {
          var kullanici = kullanicilarListesi[index];
          bool genisletildiMi = genislemeDurumlari[index];

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              children: [
                ListTile(
                  title: Text(kullanici['kullaniciAdi']),
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        genislemeDurumlari[index] = !genisletildiMi;
                      });
                    },
                    child: Text(genisletildiMi ? 'Daralt' : 'Genişlet'),
                  ),
                ),
                if (genisletildiMi)
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ad: ${kullanici['ad']}'),
                        Text('Soyad: ${kullanici['soyad']}'),
                        Text('Cinsiyet: ${kullanici['cinsiyet']}'),
                        Text('Hobiler: ${kullanici['hobiler']}'),
                        Text('Doğum Tarihi: ${kullanici['dogumTarihi']}'),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: kaydirmaMiktari > 100
          ? FloatingActionButton(
              onPressed: () {
                scrollController.animateTo(
                  curve: Curves.easeOut,
                  duration: Duration(seconds: 1),
                  0.0,
                );
              },
              child: Icon(Icons.arrow_upward_outlined),
            )
          : null,
    );
  }

  Future<void> kullanicilariYukle() async {
    String veritabaniYolu = await getDatabasesPath();
    String tamYol = join(veritabaniYolu, "kullanicilar.db");
    Database db = await openDatabase(tamYol);

    var kullanicilar = await db.query("kullanicilar");
    setState(() {
      kullanicilarListesi = kullanicilar;
      genislemeDurumlari = List<bool>.filled(kullanicilarListesi.length, false);
    });
  }
}
