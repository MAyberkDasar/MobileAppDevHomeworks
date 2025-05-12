import 'package:flutter/material.dart';
import 'gelir_gider_giris_ekrani.dart';
import 'gelir_gider_hesaplama_ekrani.dart';
import 'ayarlar_ekrani.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';

class HosgeldinizEkrani extends StatefulWidget {
  final String kullaniciAdi;

  HosgeldinizEkrani({required this.kullaniciAdi});

  @override
  _HosgeldinizEkraniDurumu createState() => _HosgeldinizEkraniDurumu();
}

class _HosgeldinizEkraniDurumu extends State<HosgeldinizEkrani> {
  String? profilResmiYolu;
  String? firmaAdi;

  @override
  void initState() {
    super.initState();
    kullaniciBilgileriniYukle();
  }

  Future<void> kullaniciBilgileriniYukle() async {
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
        profilResmiYolu = kullanici['profilResmi'] as String?;
        firmaAdi = kullanici['firmaAdi'] as String?;
      });
    }
  }

  void _menudenSecimYap(String secim, BuildContext context) {
    if (secim == 'Gelir-Gider Girişi') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GelirGiderGirisEkrani()),
      );
    } else if (secim == 'Gelir-Gider Hesaplama') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GelirGiderHesaplamaEkrani()),
      );
    } else if (secim == 'Ayarlar') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AyarlarEkrani(kullaniciAdi: widget.kullaniciAdi),
        ),
      );
    }
  }

  void _resimBuyut(BuildContext context) {
    if (profilResmiYolu == null) return;

    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) =>
            FullScreenImage(profilResmiYolu: profilResmiYolu!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hoş Geldiniz'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              _menudenSecimYap(value, context);
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'Gelir-Gider Girişi',
                  child: Text('Gelir-Gider Girişi'),
                ),
                PopupMenuItem(
                  value: 'Gelir-Gider Hesaplama',
                  child: Text('Gelir-Gider Hesaplama'),
                ),
                PopupMenuItem(
                  value: 'Ayarlar',
                  child: Text('Ayarlar'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => _resimBuyut(context),
              child: Hero(
                tag: 'profilResmi',
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profilResmiYolu != null
                      ? FileImage(File(profilResmiYolu!))
                      : null,
                  child: profilResmiYolu == null
                      ? Icon(Icons.person, size: 50)
                      : null,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              firmaAdi ?? 'Firma Adı',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String profilResmiYolu;

  FullScreenImage({required this.profilResmiYolu});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.8),
        body: Center(
          child: Hero(
            tag: 'profilResmi',
            child: ClipOval(
              child: Image.file(
                File(profilResmiYolu),
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
