void main() {
  // print(tersCevir());
  // print(enYakinAsaliBul());
  asalSayilariYazdir();
}

int tersCevir() {
  int numara = 211220006;
  String str = numara.toString();
  List sayiListesi = [];
  for (int i = 0; i < str.length; i++) {
    sayiListesi.add(str[i]);
  }
  List tersSayiListesi = sayiListesi.reversed.toList();
  String str2 = "";
  for (int i = 0; i < tersSayiListesi.length; i++) {
    str2 = str2 + tersSayiListesi[i];
  }
  int tersNumara = int.parse(str2);
  return tersNumara;
}

bool asalMi(int sayi) {
  if (sayi == 2) {
    return true;
  }
  for (int i = 2; i < sayi; i++) {
    if (sayi % i == 0) {
      return false;
    }
  }
  return true;
}

int enYakinAsaliBul() {
  int kucuk = tersCevir();
  int buyuk = tersCevir();
  while (!(asalMi(kucuk))) {
    kucuk--;
  }
  while (!(asalMi(buyuk))) {
    buyuk++;
  }
  int farkKucuk = tersCevir() - kucuk;
  int farkBuyuk = buyuk - tersCevir();
  if (farkKucuk < farkBuyuk) {
    return kucuk;
  } else if (farkBuyuk < farkKucuk) {
    return buyuk;
  }
  return buyuk;
}

int enYakinAsal = enYakinAsaliBul();

void asalSayilariYazdir() {
  for (int i = 2; i <= enYakinAsal; i++) {
    if (asalMi(i)) {
      print(i);
    }
  }
}
