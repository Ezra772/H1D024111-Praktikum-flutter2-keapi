import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tokokita/helper/api_exception.dart';
import 'package:tokokita/helper/api_url.dart';
import 'package:tokokita/model/registrasi.dart';

class RegistrasiBloc {
  static Future<Registrasi> registrasi({
    required String nama,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiUrl.registrasi),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nama': nama, 'email': email, 'password': password}),
    );

    final Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode != 200 || data['status'] != true) {
      throw ApiException(data['data'].toString());
    }
    return Registrasi.fromJson(data);
  }
}
