import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KelimeTespit extends StatefulWidget {
  const KelimeTespit({super.key});

  @override
  State<KelimeTespit> createState() => _KelimeTespitState();
}

class _KelimeTespitState extends State<KelimeTespit> {
  TextEditingController tf3 = TextEditingController();
  List<String> butunKelimeler = [];
  List<String> bulunanKelimeler = [];
  Future<void> dosyaOku() async {
    final String dosyaIcerigi =
        await rootBundle.loadString("assets/kelimeler.txt");
    setState(() {
      butunKelimeler = dosyaIcerigi.split('\n');
    });
  }

  void kelimeBul() {
    List<String> girilenHarfler = tf3.text.split(",");
    for (String kelime in butunKelimeler) {
      List<String> kelimeHarfleri = kelime.split("");
      List<String> girilenHarflerKopya = List.from(girilenHarfler);

      bool uygunMu = true;
      for (String harf in kelimeHarfleri) {
        if (!girilenHarflerKopya.remove(harf)) {
          uygunMu = false;
          break;
        }
      }
      if (uygunMu) {
        bulunanKelimeler.add(kelime);
      }
    }
    print(bulunanKelimeler);
  }

  void sifirla() {
    setState(() {
      tf3.clear();
      bulunanKelimeler.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: tf3,
                  decoration: InputDecoration(
                    hintText: "Harfler",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text("LİSTELE"),
                    onPressed: () {
                      dosyaOku();
                      kelimeBul();
                    },
                  ),
                  ElevatedButton(
                    child: Text("SIFIRLA"),
                    onPressed: sifirla,
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: bulunanKelimeler.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(bulunanKelimeler[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
