import 'dart:math';

void main() {
  List<int> zarlarToplami = [];
  List<String> aylar = [
    "Ocak",
    "Şubat",
    "Mart",
    "Nisan",
    "Mayıs",
    "Haziran",
    "Temmuz",
    "Ağustos",
    "Eylül",
    "Ekim",
    "Kasım",
    "Aralık"
  ];
  int gunSayaci = 0;
  int gunIndex = 1;
  int ayIndex = 0;
  for (int i = 1; i <= 360; i++) {
    int zar1 = Random().nextInt(6) + 1;
    int zar2 = Random().nextInt(6) + 1;
    int toplam = zar1 + zar2;
    zarlarToplami.add(toplam);
  }
  print(zarlarToplami);
  for (int sayi in zarlarToplami) {
    if (asalMi(sayi)) {
      // DateTime ilkGun = DateTime(2024, 1, 1);
      // DateTime mevcutGun = ilkGun.add(Duration(days: index));
      print(
          "Yılın ${gunIndex}. gününün tarihi = ${gunIndex % 30 == 0 ? 30 : gunIndex % 30} ${aylar[ayIndex]}"); // mevcutGun.day - aylar[mevcutGun.month - 1]
      gunSayaci++;
    }
    if ((gunIndex) % 30 == 0) {
      ayIndex++;
    }
    gunIndex++;
  }
  print("$gunSayaci gün oyun oynamıştır.");
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
