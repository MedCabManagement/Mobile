import 'package:patient/models/medicine/medicineInfo.dart';
import 'package:patient/models/schedule/schedule.dart';

class Medication {
  String? id;
  MedicineInfo medicine;
  List<Schedule>? schedules;

  Medication(
      {required this.id, required this.medicine, required this.schedules});

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['_id'],
      medicine: MedicineInfo.fromJson(json["medicine"]),
      schedules: ((json['schedules'] ?? []) as List<dynamic>)
          .map((e) => Schedule.fromJson(e))
          .toList(),
    );
  }
}
