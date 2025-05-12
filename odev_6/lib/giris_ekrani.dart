import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'hosgeldiniz_ekrani.dart';

class GirisEkrani extends StatefulWidget {
  @override
  _GirisEkraniDurumu createState() => _GirisEkraniDurumu();
}

class _GirisEkraniDurumu extends State<GirisEkrani> {
  final TextEditingController _kullaniciAdiDenetleyici =
      TextEditingController();
  final TextEditingController _parolaDenetleyici = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Giriş Yap')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _kullaniciAdiDenetleyici,
              decoration: InputDecoration(labelText: 'Kullanıcı Adı'),
            ),
            TextField(
              controller: _parolaDenetleyici,
              decoration: InputDecoration(labelText: 'Parola'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () => girisYap(context),
              child: Text('Giriş Yap'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> girisYap(BuildContext context) async {
    final kullaniciAdi = _kullaniciAdiDenetleyici.text;
    final parola = _parolaDenetleyici.text;

    final veritabaniYolu = await getDatabasesPath();
    final tamYol = join(veritabaniYolu, 'uygulama_veritabani.db');
    final veritabani = await openDatabase(tamYol);

    final sonuc = await veritabani.rawQuery(
      'SELECT * FROM kullanicilar WHERE kullaniciAdi = ? AND parola = ?',
      [kullaniciAdi, parola],
    );

    if (sonuc.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giriş Başarılı!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HosgeldinizEkrani(kullaniciAdi: kullaniciAdi),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Geçersiz Kullanıcı Adı veya Parola')),
      );
    }
  }
}
