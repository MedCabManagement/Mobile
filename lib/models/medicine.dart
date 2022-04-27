import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:patient/models/medication.dart';

class Medicine {
  String? id;
  String? name;
  String? quantity;
  String? container;

  Medicine();

  final domain = "medcab-rrc.herokuapp.com";
  Future<List> get(String _token) async {
    final url = Uri.https(domain, "/medicines");

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    final response = await http.get(url, headers: headers);

    final data = jsonDecode(response.body);

    return data;
  }
}
