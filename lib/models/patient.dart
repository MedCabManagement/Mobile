import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

const domain = "medcab-management.herokuapp.com";

class Patient {
  String? fullname;
  String? age;
  String? illness;
  String? gender;

  Patient();

  Future<int> create(
      String _fullname, String _age, String _illness, String _gender) async {
    final url = Uri.https(domain, "/patient");

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString()
    };

    final response = await http.post(url,
        headers: headers,
        body: jsonEncode({
          "fullname": _fullname,
          "age": _age,
          "illness": _illness,
          "gender": _gender
        }));

    final data = jsonDecode(response.body);

    if (response.statusCode == HttpStatus.ok) {
      fullname = data['fullname'];
      age = data['age'];
      illness = data['illness'];
      gender = data['gender'];

      Fluttertoast.showToast(
        msg: 'Created Successfuly',
        toastLength: Toast.LENGTH_LONG,
      );
    } else {}

    return response.statusCode;
  }

  Future<List> get() async {
    final url = Uri.https(domain, "/patient");

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString()
    };
    List patient = [];
    final response = await http.get(url, headers: headers);

    final data = jsonDecode(response.body);

    patient = data['data'];

    return patient;
  }

  Future<int> delete(String id) async {
    final String endPoint = "/patient/$id";

    final url = Uri.https(domain, endPoint);

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString()
    };

    final response = await http.delete(url, headers: headers);

    print(response.statusCode);

    if (response.statusCode == HttpStatus.ok) {
      Fluttertoast.showToast(
        msg: 'Deleted Successfuly',
        toastLength: Toast.LENGTH_LONG,
      );
    }

    return response.statusCode;
  }
}
