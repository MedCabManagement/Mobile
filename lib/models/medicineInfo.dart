import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


class MedicineInfo {
  String? id;
  String? name;
  int? container;
  int? quantity;

  MedicineInfo({
    required this.id,
    required this.name,
    required this.container,
    required this.quantity,
  });
  factory MedicineInfo.fromJson(Map<String, dynamic> json) {
    return MedicineInfo(
      id: json['_id'],
      name: json['name'],
      container: json['container'],
      quantity: json['quantity'],
    );
  }
}
