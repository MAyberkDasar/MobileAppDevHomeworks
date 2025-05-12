import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'giris_ekrani.dart';

class KayitEkrani extends StatefulWidget {
  @override
  _KayitEkraniDurumu createState() => _KayitEkraniDurumu();
}

class _KayitEkraniDurumu extends State<KayitEkrani> {
  final TextEditingController _kullaniciAdiDenetleyici =
      TextEditingController();
  final TextEditingController _parolaDenetleyici = TextEditingController();
  final TextEditingController _parolaTekrarDenetleyici =
      TextEditingController();
  final TextEditingController _firmaAdiDenetleyici = TextEditingController();
  File? _profilResmi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kaydol')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: resimSec,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      _profilResmi != null ? FileImage(_profilResmi!) : null,
                  child: _profilResmi == null
                      ? Icon(Icons.camera_alt, size: 50)
                      : null,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _kullaniciAdiDenetleyici,
                decoration: InputDecoration(labelText: 'Kullanıcı Adı'),
              ),
              TextField(
                controller: _parolaDenetleyici,
                decoration: InputDecoration(labelText: 'Parola'),
                obscureText: true,
              ),
              TextField(
                controller: _parolaTekrarDenetleyici,
                decoration: InputDecoration(labelText: 'Parolayı Tekrarla'),
                obscureText: true,
              ),
              TextField(
                controller: _firmaAdiDenetleyici,
                decoration: InputDecoration(labelText: 'Firma Adı'),
              ),
              ElevatedButton(
                onPressed: () => kaydet(context),
                child: Text('Kaydol'),
              ),
              ElevatedButton(
                child: Text("Giriş Yap"),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => GirisEkrani()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> resimSec() async {
    final secilenResim =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (secilenResim != null) {
      setState(() {
        _profilResmi = File(secilenResim.path);
      });
    }
  }

  Future<void> kaydet(BuildContext context) async {
    final kullaniciAdi = _kullaniciAdiDenetleyici.text;
    final parola = _parolaDenetleyici.text;
    final parolaTekrar = _parolaTekrarDenetleyici.text;
    final firmaAdi = _firmaAdiDenetleyici.text;

    if (parola != parolaTekrar) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Parolalar eşleşmiyor!')),
      );
      return;
    }

    if (_profilResmi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen bir profil resmi seçin!')),
      );
      return;
    }

    final veritabaniYolu = await getDatabasesPath();
    final tamYol = join(veritabaniYolu, 'uygulama_veritabani.db');
    final veritabani =
        await openDatabase(tamYol, version: 1, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE kullanicilar (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          kullaniciAdi TEXT NOT NULL,
          parola TEXT NOT NULL,
          firmaAdi TEXT,
          profilResmi TEXT
        )
      ''');
      db.execute('''
        CREATE TABLE islemler (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          tur TEXT NOT NULL,
          miktar REAL NOT NULL,
          aciklama TEXT,
          tarih TEXT
        )
      ''');
    });

    await veritabani.insert('kullanicilar', {
      'kullaniciAdi': kullaniciAdi,
      'parola': parola,
      'firmaAdi': firmaAdi,
      'profilResmi': _profilResmi!.path,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Kayıt Başarılı!')),
    );

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => GirisEkrani()));
  }
}
