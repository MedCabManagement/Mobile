import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Medicine {
  String? id;
  String? name;
  int? quantity;
  int? container;

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

  Future getMedicine(String _id, String _token) async {
    final url = Uri.https(domain, "/medicines/$_id");

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    final response = await http.get(url, headers: headers);

    final data = jsonDecode(response.body);

    // print(data);

    if (_id == "") {
      return data[0];
    }

    return data;
  }

  Future<int> post(
      String _name, int _quantity, int _container, String _token) async {
    final url = Uri.https(domain, "/medicines");

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    final response = await http.post(url,
        headers: headers,
        body: jsonEncode({
          "name": _name,
          "container": _container,
          "quantity": _quantity,
        }));

    final data = jsonDecode(response.body);

    if (response.statusCode == HttpStatus.ok) {
      name = data["name"];
      container = data["container"];
      quantity = data["quantity"];

      Fluttertoast.showToast(
        msg: 'Medicine has been added',
        toastLength: Toast.LENGTH_LONG,
      );
    } else {}

    return response.statusCode;
  }

  Future<int> edit(String _medID, String _name, int _quantity, int _container,
      String _token) async {
    final url = Uri.https(domain, "/medicines/$_medID");

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    final response = await http.patch(url,
        headers: headers,
        body: jsonEncode({
          "name": _name,
          "quantity": _quantity,
          "container": _container,
        }));

    if (response.statusCode == HttpStatus.ok) {
      Fluttertoast.showToast(
        msg: 'Medicine has been updated',
        toastLength: Toast.LENGTH_LONG,
      );
    } else {}

    return response.statusCode;
  }

  Future<int> delete(String _medID, String _token) async {
    final url = Uri.https(domain, "/medicines/$_medID");

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    final response = await http.delete(url, headers: headers);

    if (response.statusCode == HttpStatus.ok) {
      Fluttertoast.showToast(
        msg: 'Medicine has been deleted!',
        toastLength: Toast.LENGTH_LONG,
      );
    } else {}

    return response.statusCode;
  }
}
