import 'package:flutter/material.dart';
import 'package:patient/models/medication/medication.dart';
import 'package:patient/models/patient/patient.dart';
import 'package:patient/models/schedule/schedule.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:patient/theme/theme.dart';

class AddSchedule extends StatefulWidget {
  final String id, token, medID;
  const AddSchedule(this.id, this.token, this.medID, {Key? key})
      : super(key: key);

  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  final patient = Patient();
  DateTime _dateTime = DateTime.now();

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

  Widget hourMinute12HCustomStyle() {
    return TimePickerSpinner(
      is24HourMode: false,
      normalTextStyle: const TextStyle(fontSize: 17.5, color: Colors.black),
      highlightedTextStyle: const TextStyle(
          fontSize: 30, color: Colors.greenAccent, fontWeight: FontWeight.bold),
      spacing: 40,
      itemWidth: 50,
      itemHeight: 68,
      isForce2Digits: true,
      minutesInterval: 1,
      onTimeChange: (time) {
        setState(() {
          _dateTime = time;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // items.entries.map(
    //   (element) {
    //     if (element.value == true && !days.contains(element.key)) {
    //       days.add(element.key);
    //     } else if (element.value == false) {
    //       days.remove(element.key);
    //     }
    //   },
    // ).toList();

    for (final entry in items.entries) {
      if (entry.value && !days.contains(entry.key)) {
        days.add(entry.key);
      } else if (!entry.value) {
        days.remove(entry.key);
      }
    }

    int time = ((_dateTime.hour * 3600) + (_dateTime.minute * 60));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.customGreen,
        centerTitle: true,
        title: const Text("Set Schedule"),
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
                      final statusCode = await patient.setSchedule(
                          widget.id, widget.medID, days, time, widget.token);

                      if (statusCode == 200) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Set",
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
                  hourMinute12HCustomStyle(),
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
