import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:patient/models/user.dart';

const domain = "medcab-rrc.herokuapp.com";

class Patient {
  String? name;
  String? age;

  Patient();

  Future<int> create(String _name, String _age) async {
    final url = Uri.https(domain, "/patient");

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
    };

    final response = await http.post(url,
        headers: headers,
        body: jsonEncode({
          "name": _name,
          "age": _age,
        }));

    final data = jsonDecode(response.body);

    if (response.statusCode == HttpStatus.ok) {
      name = data['name'];
      age = data['age'];

      Fluttertoast.showToast(
        msg: 'Created Successfuly',
        toastLength: Toast.LENGTH_LONG,
      );
    } else {}

    return response.statusCode;
  }

  Future<List> get(String token) async {
    final url = Uri.https(domain, "/patients");

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer $token"
    };
    List patient = [];
    final response = await http.get(url, headers: headers);

    final data = jsonDecode(response.body);

    return data;
  }

  Future<int> delete(String id) async {
    final String endPoint = "/patient/$id";

    final url = Uri.https(domain, endPoint);

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString()
    };

    final response = await http.delete(url, headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      Fluttertoast.showToast(
        msg: 'Deleted Successfuly',
        toastLength: Toast.LENGTH_LONG,
      );
    }

    return response.statusCode;
  }
}
