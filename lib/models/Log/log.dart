import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


class Log {
  String? id;
  String? medicationId;
  String? patientID;
  String? patientName;
  String? medicineId;
  String? medicineName;
  String? schedule;
  String? status;

  Log(
      {
      this.id,
      this.medicationId,
      this.patientID,
      this.patientName,
      this.medicineId,
      this.medicineName,
      this.schedule,
      this.status
      });

  Future<List<Log>>? refresh(String token) async {
    final url = Uri.https("medcab-rrc.herokuapp.com", "/logs");

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer $token"
    };

    final response = await http.get(url, headers: headers);

    final data = jsonDecode(response.body);

    return (data as List<dynamic>)
        .map((log) => Log(
            id: log['_id'],
            medicationId: log['medicationId'],
            patientID: log['patientId'],
            patientName: log['patientName'],
            medicineId: log['medicineId'],
            medicineName: log['medicineName'],
            schedule: log['schedule'],
            status: log['status']))
        .toList();
  }
}
