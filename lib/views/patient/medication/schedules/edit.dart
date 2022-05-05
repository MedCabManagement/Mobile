import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:patient/models/medication/medication.dart';
import 'package:patient/models/patient/patient.dart';
import 'package:patient/models/schedule/schedule.dart';
import 'package:patient/views/patient/medication/view.dart';

class EditSchedule extends StatefulWidget {
  final Schedule _schedule;
  final Medication _medication;
  final String _patientID, _token;

  const EditSchedule(
      this._schedule, this._patientID, this._medication, this._token,
      {Key? key})
      : super(key: key);

  @override
  State<EditSchedule> createState() => _EditScheduleState();
}

class _EditScheduleState extends State<EditSchedule> {
  final patient = Patient();
  late DateTime _dateTime;

  Map<String, bool> items = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false
  };

  List<String> days = [];

  refresh() {
    return patient.getOneMedication(
        widget._patientID, widget._medication.id.toString(), widget._token);
  }

  @override
  void initState() {
    super.initState();

    _dateTime = widget._schedule.toDateTime();
  }

  @override
  Widget build(BuildContext context) {
    for (final entry in items.entries) {
      if (entry.value && !days.contains(entry.key)) {
        days.add(entry.key);
      } else if (!entry.value) {
        days.remove(entry.key);
      }

      if (widget._schedule.days!.contains(entry.key)) {
        items.update(entry.key, (value) => true);
      }
    }

    int time = ((_dateTime.hour * 3600) + (_dateTime.minute * 60));

    print(time);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text("Edit"),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 51, 118, 56),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Padding(
                padding: const EdgeInsets.all(5),
                child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ))),
            const Spacer(),
            Padding(
                padding: const EdgeInsets.all(5),
                child: TextButton(
                    onPressed: () async {
                      final statusCode = await patient.editSchedule(
                          widget._patientID,
                          widget._medication.id.toString(),
                          widget._schedule.id.toString(),
                          days,
                          time,
                          widget._token);

                      if (statusCode == 200) {
                        Navigator.pop(context);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => ViewMeds(widget._medication,
                                widget._patientID, widget._token)));
                      }
                    },
                    child: const Text("Save",
                        style: TextStyle(color: Colors.white, fontSize: 16)))),
            const Spacer(),
          ],
        ),
      ),
      body: ListView(
        children: [
          Column(children: [
            ...items.keys
                .map((t) => CheckboxListTile(
                      title: Text(t),
                      value: items[t],
                      onChanged: (val) {
                        setState(() {
                          items[t] = val as bool;
                        });
                      },
                    ))
                .toList(),
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  TimePickerSpinner(
                    time: _dateTime,
                    is24HourMode: false,
                    normalTextStyle:
                        const TextStyle(fontSize: 17.5, color: Colors.black),
                    highlightedTextStyle: const TextStyle(
                        fontSize: 30,
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold),
                    spacing: 40,
                    itemWidth: 50,
                    itemHeight: 68,
                    isForce2Digits: true,
                    minutesInterval: 1,
                    onTimeChange: (time) {
                      setState(() {
                        _dateTime = DateTime(
                            2022, 08, 22, time.hour, time.minute, time.second);
                      });
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 50),
                    child: Text(
                      _dateTime.hour.toString().padLeft(2, '0') +
                          ':' +
                          _dateTime.minute.toString().padLeft(2, '0'),
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent),
                    ),
                  ),
                ],
              ),
            )
          ]),
        ],
      ),
    );
  }
}
