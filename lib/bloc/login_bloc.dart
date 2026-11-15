import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tokokita/helper/api_exception.dart';
import 'package:tokokita/helper/api_url.dart';
import 'package:tokokita/model/login.dart';

class LoginBloc {
  static Future<Login> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiUrl.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    Map<String, dynamic> data;
    try {
      data = jsonDecode(response.body);
    } catch (_) {
      throw ApiException(
          "Format respons salah (${response.statusCode}): ${response.body.length > 100 ? response.body.substring(0, 100) : response.body}");
    }

    if (response.statusCode != 200 || data['status'] != true) {
      throw ApiException(data['data']?.toString() ?? 'Login gagal');
    }
    return Login.fromJson(data);
  }
}
