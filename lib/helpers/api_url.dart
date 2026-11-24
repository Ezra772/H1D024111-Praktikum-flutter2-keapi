import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiUrl {
  /// Base URL API.
  /// - Android Emulator  : 10.0.2.2  (alias localhost di dalam emulator)
  /// - HP Fisik via USB  : gunakan adb reverse, lalu pakai 127.0.0.1
  /// - HP Fisik via Wi-Fi: IP laptop di jaringan yang sama (lihat ipconfig)
  static String get baseUrl {
    if (!kIsWeb && Platform.isAndroid) {
      // HP Fisik via USB (adb reverse tcp:80 tcp:80): pakai localhost
      // Android Emulator: pakai 10.0.2.2
      // HP Fisik via Wi-Fi (tanpa adb reverse): pakai IP laptop, misal 10.228.243.131
      return 'http://localhost/toko-api/public';
    }
    return 'http://localhost/toko-api/public';
  }

  static String get registrasi => '$baseUrl/registrasi';
  static String get login => '$baseUrl/login';
  static String get listProduk => '$baseUrl/produk';
  static String get createProduk => '$baseUrl/produk';

  static String updateProduk(int id) => '$baseUrl/produk/$id/update';
  static String showProduk(int id) => '$baseUrl/produk/$id';
  static String deleteProduk(int id) => '$baseUrl/produk/$id';
}
