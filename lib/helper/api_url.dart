import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiUrl {
  // Otomatis deteksi platform:
  // - Android emulator: 10.0.2.2
  // - Windows / Web: localhost
  // Catatan: Jika menggunakan HP fisik via Wi-Fi, ganti host dengan IP laptop (misal: 192.168.18.53)
  static String get baseUrl {
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2/toko-api/codeigniter4-framework-d755dca/public';
    }
    return 'http://localhost/toko-api/codeigniter4-framework-d755dca/public';
  }

  static String get registrasi => '$baseUrl/registrasi';
  static String get login => '$baseUrl/login';
  static String get listProduk => '$baseUrl/produk';

  static String detailProduk(int id) => '$baseUrl/produk/$id';
  static String updateProduk(int id) => '$baseUrl/produk/$id/update';
  static String deleteProduk(int id) => '$baseUrl/produk/$id';
}
