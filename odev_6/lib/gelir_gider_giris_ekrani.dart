import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class GelirGiderGirisEkrani extends StatefulWidget {
  @override
  _GelirGiderGirisEkraniDurumu createState() => _GelirGiderGirisEkraniDurumu();
}

class _GelirGiderGirisEkraniDurumu extends State<GelirGiderGirisEkrani> {
  final TextEditingController _miktarDenetleyici = TextEditingController();
  final TextEditingController _aciklamaDenetleyici = TextEditingController();
  String _islemTuru = 'gelir';
  DateTime? _secilenTarih;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gelir-Gider Girişi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                value: _islemTuru,
                items: [
                  DropdownMenuItem(
                    value: 'gelir',
                    child: Text('Gelir'),
                  ),
                  DropdownMenuItem(
                    value: 'gider',
                    child: Text('Gider'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _islemTuru = value!;
                  });
                },
              ),
              TextField(
                controller: _miktarDenetleyici,
                decoration: InputDecoration(labelText: 'Tutar'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _aciklamaDenetleyici,
                decoration: InputDecoration(labelText: 'Açıklama'),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _tarihSec(context),
                    child: Text('Tarih Seç'),
                  ),
                  SizedBox(width: 16),
                  Text(
                    _secilenTarih == null
                        ? 'Tarih Seçilmedi'
                        : '${_secilenTarih!.day}/${_secilenTarih!.month}/${_secilenTarih!.year}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => _islemKaydet(context),
                  child: Text('Kaydet'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _tarihSec(BuildContext context) async {
    final secilenTarih = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (secilenTarih != null) {
      setState(() {
        _secilenTarih = secilenTarih;
      });
    }
  }

  Future<void> _islemKaydet(BuildContext context) async {
    if (_secilenTarih == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lütfen bir tarih seçin!')),
      );
      return;
    }

    final miktar = double.tryParse(_miktarDenetleyici.text) ?? 0;
    final aciklama = _aciklamaDenetleyici.text;
    final tarih = _secilenTarih!.toIso8601String();

    final veritabaniYolu = await getDatabasesPath();
    final tamYol = join(veritabaniYolu, 'uygulama_veritabani.db');
    final veritabani = await openDatabase(tamYol);

    await veritabani.insert('islemler', {
      'tur': _islemTuru,
      'miktar': miktar,
      'aciklama': aciklama,
      'tarih': tarih,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('İşlem Kaydedildi!')),
    );

    _miktarDenetleyici.clear();
    _aciklamaDenetleyici.clear();
    setState(() {
      _secilenTarih = null;
    });
  }
}
