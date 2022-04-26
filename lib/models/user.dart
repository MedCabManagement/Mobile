import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

const domain = "medcab-rrc.herokuapp.com";

class User {
  String? email;
  String? password;
  String? name;
  String? token;

  User();

  Future<int> login(String _email, String _password) async {
    final url = Uri.https(domain, "/users/login/");

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString()
    };
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode({"email": _email, "password": _password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == HttpStatus.ok) {
      email = data['email'];
      name = data['name'];
      token = data['token'];
    } else {
      Fluttertoast.showToast(
        msg: data['error'] ?? 'Failed to login',
        toastLength: Toast.LENGTH_LONG,
      );
    }
    return response.statusCode;
  }

  Future<int> logout(String _token) async {
    final url = Uri.https(domain, "/users/logout/");

    final headers = <String, String>{
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };
    final response = await http.post(
      url,
      headers: headers,
    );
    return response.statusCode;
  }
}
