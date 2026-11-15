import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tokokita/helper/api_exception.dart';
import 'package:tokokita/helper/api_url.dart';
import 'package:tokokita/helper/user_info.dart';
import 'package:tokokita/model/produk.dart';

class ProdukBloc {
  // Helper: buat header dengan token Authorization
  static Future<Map<String, String>> _getHeaders() async {
    final token = await UserInfo().getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static Future<List<Produk>> getProduks() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse(ApiUrl.listProduk),
      headers: headers,
    );

    final Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode != 200 || data['status'] != true) {
      throw ApiException(data['data'].toString());
    }
    final List list = data['data'] as List;
    return list.map((item) => Produk.fromJson(item)).toList();
  }

  static Future<Produk> detailProduk({required int id}) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse(ApiUrl.detailProduk(id)),
      headers: headers,
    );

    final Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode != 200 || data['status'] != true) {
      throw ApiException(data['data'].toString());
    }
    return Produk.fromJson(data['data']);
  }

  static Future<Produk> createProduk({
    required String kodeProduk,
    required String namaProduk,
    required int hargaProduk,
  }) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse(ApiUrl.listProduk),
      headers: headers,
      body: jsonEncode({
        'kode_produk': kodeProduk,
        'nama_produk': namaProduk,
        'harga': hargaProduk,
      }),
    );

    final Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode != 200 || data['status'] != true) {
      throw ApiException(data['data'].toString());
    }
    return Produk.fromJson(data['data']);
  }

  static Future<bool> updateProduk({
    required int id,
    required String kodeProduk,
    required String namaProduk,
    required int hargaProduk,
  }) async {
    final headers = await _getHeaders();
    // Gunakan POST ke /produk/{id}/update (lebih kompatibel dari PUT di berbagai server)
    final response = await http.post(
      Uri.parse(ApiUrl.updateProduk(id)),
      headers: headers,
      body: jsonEncode({
        'kode_produk': kodeProduk,
        'nama_produk': namaProduk,
        'harga': hargaProduk,
      }),
    );

    final Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode != 200 || data['status'] != true) {
      throw ApiException(data['data'].toString());
    }
    return true;
  }

  static Future<bool> deleteProduk({required int id}) async {
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse(ApiUrl.deleteProduk(id)),
      headers: headers,
    );

    final Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode != 200 || data['status'] != true) {
      throw ApiException(data['data'].toString());
    }
    return true;
  }
}
