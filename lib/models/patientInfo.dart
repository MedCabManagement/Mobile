import 'package:patient/models/medication.dart';

class PatientInfo {
  String? id;
  String? name;
  int? age;
  List<Medication>? medications;

  PatientInfo(
      {required this.id,
      required this.name,
      required this.age,
      required this.medications});

  factory PatientInfo.fromJson(Map<String, dynamic> json) {
    return PatientInfo(
        id: json['_id'],
        name: json['name'],
        age: json['age'],
        medications: (json['medications'] as List<dynamic>)
            .map((e) => Medication.fromJson(e))
            .toList());
  }
}
