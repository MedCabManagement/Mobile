import 'dart:async';
import 'package:flutter/material.dart';
import 'package:patient/models/account.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  final User user;
  const Home(this.user, {Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selected_screen = 0;

  final textStyle = const TextStyle(fontSize: 20, color: Colors.white60);
  DateTime? date;
  TimeOfDay? time;

  String getDate() {
    if (date == null) {
      return 'SELECT DATE';
    } else {
      return "${date?.month}/${date?.day}/${date?.year}";
    }
  }

  String getTime() {
    if (time == null) {
      return 'SELECT TIME';
    } else {
      return "${time?.hour}:${time?.minute.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: selected_screen == 0
              ? Text("Set Schedule", style: textStyle)
              : selected_screen == 1
                  ? Text("Records", style: textStyle)
                  : Text("Medicines", style: textStyle)),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selected_screen,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.lock_clock_outlined), label: 'Schedule'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Records'),
            BottomNavigationBarItem(
                icon: Icon(Icons.medication), label: 'Medicine'),
          ],
          onTap: (index) {
            setState(() {
              selected_screen = index;
            });
          }),
      body: selected_screen == 0
          ? homeScreen(context)
          : selected_screen == 1
              ? recordScreen()
              : medicineScreen(),
    );
  }

  Future pickDate(BuildContext context) async {
    final initalDate = DateTime.now();

    final newDate = await showDatePicker(
        context: context,
        initialDate: initalDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));

    if (newDate == null) return;

    setState(() => date = newDate);
  }

  Future pickTime(BuildContext context) async {
    final initalDate = new TimeOfDay.now();

    final newTime =
        await showTimePicker(context: context, initialTime: initalDate);

    if (newTime == null) return;

    setState(() => time = newTime);
  }

  Widget homeScreen(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 120, 20, 25),
      children: [
        Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
              side: const BorderSide(
                  color: Color.fromARGB(179, 237, 94, 94), width: 1),
              borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: ListTile(
              leading: const Icon(Icons.date_range_outlined),
              title: Text(getDate(),
                  style: const TextStyle(
                    fontFamily: 'RobotoMono',
                    fontSize: 18,
                  )),
              onTap: () => pickDate(context),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
              side: const BorderSide(
                  color: Color.fromARGB(179, 237, 94, 94), width: 1),
              borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: ListTile(
              leading: const Icon(Icons.timer),
              title: Text(getTime(),
                  style: const TextStyle(
                    fontFamily: 'RobotoMono',
                    fontSize: 18,
                  )),
              onTap: () => pickTime(context),
            ),
          ),
        ),
        const SizedBox(height: 10.0),
        Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
              side: const BorderSide(
                  color: Color.fromARGB(179, 237, 94, 94), width: 1),
              borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: ListTile(
              leading: const Icon(Icons.medical_services_outlined),
              title: const Text('SELECT MEDICINE',
                  style: TextStyle(
                    fontFamily: 'RobotoMono',
                    fontSize: 18,
                  )),
              onTap: () {},
            ),
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  Widget recordScreen() {
    return ListView();
  }

  Widget medicineScreen() {
    return ListView();
  }
}
