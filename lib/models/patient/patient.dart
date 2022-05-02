import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:patient/models/medication/medication.dart';
import 'package:patient/models/schedule/schedule.dart';
import 'package:patient/views/patient/medication/schedules/view.dart';

const domain = "medcab-rrc.herokuapp.com";

class Patient {
  String? name;
  int? age;

  Patient();

  Future<int> create(String _name, int _age, String _token) async {
    final url = Uri.https(domain, "/patients");

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer $_token"
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

    final response = await http.get(url, headers: headers);

    final data = jsonDecode(response.body);

    return data;
  }

  Future<int> delete(String id) async {
    final String endPoint = "/patients/$id";

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

  // Future<List<Medicine>> getMedications(String _id, String _token) async {
  //   final url = Uri.https(domain, "/patients/$_id/medications");

  //   final headers = <String, String>{
  //     HttpHeaders.contentTypeHeader: ContentType.json.toString(),
  //     HttpHeaders.acceptHeader: ContentType.json.toString(),
  //     HttpHeaders.authorizationHeader: "Bearer $_token"
  //   };

  //   final response = await http.get(url, headers: headers);

  //   final data = jsonDecode(response.body) as List<dynamic>;

  //   final medicines = data.map((e) => Medicine.fromJson(e)).toList();

  //   return medicines;
  // }

  Future getPatient(String _id, String _token) async {
    final url = Uri.https(domain, "/patients/$_id/");
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    final response = await http.get(url, headers: headers);

    final data = jsonDecode(response.body);

    // print(data);

    return data;
  }

  Future<List<Medication>> getMedications(String _id, String _token) async {
    final url = Uri.https(domain, "/patients/$_id/medications");

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    final response = await http.get(url, headers: headers);

    final data = jsonDecode(response.body) as List<dynamic>;

    final med = data.map((e) => Medication.fromJson(e)).toList();

    return med;
  }

  Future<int> addMedication(String _id, String _medicineId, String _token) async {
    final url = Uri.https(domain, "/patients/$_id/medications");

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    final response = await http.post(url,
        headers: headers,
        body: jsonEncode({
          "medicine": _medicineId,
        }));

    final data = jsonDecode(response.body);

    if (response.statusCode == HttpStatus.ok) {
      Fluttertoast.showToast(
        msg: 'Medicine Succesfully Added',
        toastLength: Toast.LENGTH_LONG,
      );
    } else {}

    print(response.statusCode);

    return response.statusCode;
  }
  Future<List<Schedule>> getOneMedication(String _id, String _medId, String _token) async {
    
    final url = Uri.https(domain, "/patients/$_id/medications/$_medId");

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer $_token"
    };

    final response = await http.get(url, headers: headers);

    final data = jsonDecode(response.body);

    // data["schedules"] as List<dynamic>).map((e) => Schedule.fromJson(e)).toList();

    final schedules = (data["schedules"] as List<dynamic>).map((e) => Schedule.fromJson(e)).toList();

    print(schedules);

    

    return schedules;
  }
}
