import 'package:flutter/material.dart';
import 'package:odev_5/tum_kullanicilar.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class Bilgilerim extends StatefulWidget {
  final String kullaniciAdi;
  Bilgilerim({required this.kullaniciAdi});

  @override
  State<Bilgilerim> createState() => _BilgilerimState();
}

class _BilgilerimState extends State<Bilgilerim> {
  TextEditingController adController = TextEditingController();
  TextEditingController soyadController = TextEditingController();
  String cinsiyet = "Erkek";
  DateTime? dogumTarihi;
  List<String> tumHobiler = [
    "Müzik dinlemek",
    "Spor yapmak",
    "Kitap okumak",
    "Oyun oynamak",
    "Dizi izlemek"
  ];
  List<String> secilenHobiler = [];
  ScrollController scrollController = ScrollController();
  double kaydirmaMiktari = 0.0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      setState(() {
        kaydirmaMiktari = scrollController.offset;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.kullaniciAdi}"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextField(
                controller: adController,
                decoration: InputDecoration(
                  hintText: "Ad",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: soyadController,
                decoration: InputDecoration(
                  hintText: "Soyad",
                  border: OutlineInputBorder(),
                ),
              ),
              RadioListTile(
                value: "Erkek",
                groupValue: cinsiyet,
                onChanged: (value) {
                  setState(() {
                    cinsiyet = value!;
                  });
                },
                title: Text("Erkek"),
              ),
              RadioListTile(
                value: "Kadın",
                groupValue: cinsiyet,
                onChanged: (value) {
                  setState(() {
                    cinsiyet = value!;
                  });
                },
                title: Text("Kadın"),
              ),
              ElevatedButton(
                child: Text("Doğum Tarihi Seç"),
                onPressed: () async {
                  var secilenTarih = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  setState(() {
                    dogumTarihi = secilenTarih;
                  });
                },
              ),
              for (var hobi in tumHobiler)
                CheckboxListTile(
                  title: Text(hobi),
                  value: secilenHobiler.contains(hobi),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        secilenHobiler.add(hobi);
                      } else {
                        secilenHobiler.remove(hobi);
                      }
                    });
                  },
                ),
              ElevatedButton(
                child: Text("Kaydet"),
                onPressed: () {
                  kaydet(context);
                },
              ),
            ],
          ),
        ),
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

  Future<void> kaydet(BuildContext context) async {
    String veritabaniYolu = await getDatabasesPath();
    String tamYol = join(veritabaniYolu, "kullanicilar.db");
    Database db = await openDatabase(tamYol);

    await db.update(
      "kullanicilar",
      {
        "ad": adController.text,
        "soyad": soyadController.text,
        "cinsiyet": cinsiyet,
        "hobiler": secilenHobiler.join(","),
        "dogumTarihi": DateFormat("dd-MM-yyyy").format(dogumTarihi!),
      },
      where: "kullaniciAdi = ?",
      whereArgs: [widget.kullaniciAdi],
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Kayıt Başarılı"),
          content: Text("Bilgileriniz kaydedildi"),
          actions: [
            TextButton(
              child: Text("İptal"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Kullanıcıları Listele"),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TumKullanicilar(),
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
