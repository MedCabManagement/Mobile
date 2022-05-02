import 'package:flutter/material.dart';
import 'package:patient/models/medication/medication.dart';
import 'package:patient/models/patient/patient.dart';
import 'package:patient/models/schedule/schedule.dart';

class AddSchedule extends StatefulWidget {
  final String id, token;
  const AddSchedule(this.id, this.token, {Key? key})
      : super(key: key);

  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  final patient = Patient();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text("AddSchedule"),
      ),
    );
  }
}
