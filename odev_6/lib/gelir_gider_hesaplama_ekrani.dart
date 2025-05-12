import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class GelirGiderHesaplamaEkrani extends StatefulWidget {
  @override
  _GelirGiderHesaplamaEkraniDurumu createState() =>
      _GelirGiderHesaplamaEkraniDurumu();
}

class _GelirGiderHesaplamaEkraniDurumu
    extends State<GelirGiderHesaplamaEkrani> {
  List<Map<String, dynamic>> islemler = [];
  double toplamGelir = 0;
  double toplamGider = 0;

  DateTime? baslangicTarihi;
  DateTime? bitisTarihi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gelir-Gider Hesaplama')),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _baslangicTarihiSec(context),
                child: Text('Başlangıç Tarihi'),
              ),
              ElevatedButton(
                onPressed: () => _bitisTarihiSec(context),
                child: Text('Bitiş Tarihi'),
              ),
            ],
          ),
          SizedBox(height: 10),
          if (baslangicTarihi != null || bitisTarihi != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Seçilen Tarihler: ${_tarihFormatla(baslangicTarihi)} - ${_tarihFormatla(bitisTarihi)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ElevatedButton(
            onPressed: () => _hesapla(context),
            child: Text('Hesapla'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: islemler.length,
              itemBuilder: (context, index) {
                final islem = islemler[index];
                return ListTile(
                  title: Text(islem['aciklama']),
                  subtitle:
                      Text(_tarihFormatla(DateTime.parse(islem['tarih']))),
                  trailing: Text('${islem['miktar']} TL'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text('Toplam Gelir: $toplamGelir TL',
                    style: TextStyle(fontSize: 18)),
                Text('Toplam Gider: $toplamGider TL',
                    style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _baslangicTarihiSec(BuildContext context) async {
    final secilenTarih = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (secilenTarih != null) {
      setState(() {
        baslangicTarihi = secilenTarih;
      });
    }
  }

  Future<void> _bitisTarihiSec(BuildContext context) async {
    final secilenTarih = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (secilenTarih != null) {
      setState(() {
        bitisTarihi = secilenTarih;
      });
    }
  }

  Future<void> _hesapla(BuildContext context) async {
    if (baslangicTarihi == null || bitisTarihi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen tarih aralığını seçin!')),
      );
      return;
    }

    final veritabaniYolu = await getDatabasesPath();
    final tamYol = join(veritabaniYolu, 'uygulama_veritabani.db');
    final veritabani = await openDatabase(tamYol);

    final baslangic = baslangicTarihi!.toIso8601String();
    final bitis = bitisTarihi!.toIso8601String();

    final sonuc = await veritabani.rawQuery(
      'SELECT * FROM islemler WHERE tarih BETWEEN ? AND ?',
      [baslangic, bitis],
    );

    double gelir = 0;
    double gider = 0;

    sonuc.forEach((islem) {
      if (islem['tur'] == 'gelir') {
        gelir += (islem['miktar'] as num).toDouble();
      } else {
        gider += (islem['miktar'] as num).toDouble();
      }
    });

    setState(() {
      islemler = sonuc;
      toplamGelir = gelir;
      toplamGider = gider;
    });
  }

  String _tarihFormatla(DateTime? tarih) {
    if (tarih == null) return 'Tarih seçilmedi';
    return '${tarih.day}/${tarih.month}/${tarih.year}';
  }
}
