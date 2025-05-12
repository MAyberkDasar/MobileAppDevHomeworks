import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AyarlarEkrani extends StatefulWidget {
  final String kullaniciAdi;

  AyarlarEkrani({required this.kullaniciAdi});

  @override
  _AyarlarEkraniDurumu createState() => _AyarlarEkraniDurumu();
}

class _AyarlarEkraniDurumu extends State<AyarlarEkrani> {
  final TextEditingController _kullaniciAdiDenetleyici =
      TextEditingController();
  final TextEditingController _parolaDenetleyici = TextEditingController();
  final TextEditingController _firmaAdiDenetleyici = TextEditingController();
  File? _profilResmi;

  @override
  void initState() {
    super.initState();
    _kullaniciBilgileriniYukle();
  }

  Future<void> _kullaniciBilgileriniYukle() async {
    final veritabaniYolu = await getDatabasesPath();
    final tamYol = join(veritabaniYolu, 'uygulama_veritabani.db');
    final veritabani = await openDatabase(tamYol);

    final sonuc = await veritabani.rawQuery(
      'SELECT * FROM kullanicilar WHERE kullaniciAdi = ?',
      [widget.kullaniciAdi],
    );

    if (sonuc.isNotEmpty) {
      final kullanici = sonuc.first;
      setState(() {
        _kullaniciAdiDenetleyici.text =
            kullanici['kullaniciAdi'] as String? ?? '';
        _parolaDenetleyici.text = kullanici['parola'] as String? ?? '';
        _firmaAdiDenetleyici.text = kullanici['firmaAdi'] as String? ?? '';
        if (kullanici['profilResmi'] != null) {
          _profilResmi = kullanici['profilResmi'] != null
              ? File(kullanici['profilResmi'] as String)
              : null;
        }
      });
    }
  }

  Future<void> _resimSec() async {
    final secilenResim =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (secilenResim != null) {
      setState(() {
        _profilResmi = File(secilenResim.path);
      });
    }
  }

  Future<void> _kullaniciGuncelle(BuildContext context) async {
    final veritabaniYolu = await getDatabasesPath();
    final tamYol = join(veritabaniYolu, 'uygulama_veritabani.db');
    final veritabani = await openDatabase(tamYol);

    await veritabani.update(
      'kullanicilar',
      {
        'kullaniciAdi': _kullaniciAdiDenetleyici.text,
        'parola': _parolaDenetleyici.text,
        'firmaAdi': _firmaAdiDenetleyici.text,
        'profilResmi': _profilResmi?.path,
      },
      where: 'kullaniciAdi = ?',
      whereArgs: [widget.kullaniciAdi],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bilgiler Güncellendi!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ayarlar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _resimSec,
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
                controller: _firmaAdiDenetleyici,
                decoration: InputDecoration(labelText: 'Firma Adı'),
              ),
              ElevatedButton(
                onPressed: () => _kullaniciGuncelle(context),
                child: Text('Güncelle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
