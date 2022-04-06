import 'dart:async';
import 'package:flutter/material.dart';
import 'package:patient/models/account.dart';
import 'package:patient/models/patient.dart';
import './login.dart';
import './patient/create_patient.dart';
import '../views/patient/Profile.dart';

class Home extends StatefulWidget {
  final User user;
  const Home(this.user, {Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selected_screen = 0;
  int tab_selected = 0;

  final patient = Patient();

  final textStyle = const TextStyle(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontFamily: "OpenSans");
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
      backgroundColor: Colors.green[50],
      appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: selected_screen == 0
              ? Text("Set Schedule", style: textStyle)
              : selected_screen == 1
                  ? Text("Records", style: textStyle)
                  : Text("Medicines", style: textStyle)),
      drawer: Drawer(
        backgroundColor: Colors.green[50],
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
          children: [
            const CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Icon(Icons.person, color: Colors.white, size: 100),
              radius: 60,
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                widget.user.name!.toUpperCase(),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 350),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const Login(),
                  ));
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label:
                    const Text('Sign out', style: TextStyle(color: Colors.red)),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.green,
          currentIndex: selected_screen,
          items: const [
            BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(Icons.lock_clock_outlined),
                label: 'Schedule'),
            BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(Icons.list),
                label: 'Records'),
            BottomNavigationBarItem(
                backgroundColor: Colors.black,
                icon: Icon(Icons.medication),
                label: 'Medicine'),
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
    final initalDate = TimeOfDay.now();

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
              side: const BorderSide(color: Colors.greenAccent, width: 1),
              borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: ListTile(
              leading: const Icon(Icons.date_range_outlined),
              title: Text(getDate(),
                  style: const TextStyle(
                    fontFamily: 'OpenSans',
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
              side: const BorderSide(color: Colors.greenAccent, width: 1),
              borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: ListTile(
              leading: const Icon(Icons.timer),
              title: Text(getTime(),
                  style: const TextStyle(
                    fontFamily: 'OpenSans',
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
              side: const BorderSide(color: Colors.greenAccent, width: 1),
              borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: ListTile(
              leading: const Icon(Icons.medical_services_outlined),
              title: const Text('SELECT MEDICINE',
                  style: TextStyle(
                    fontFamily: 'OpenSans',
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
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.green,
                toolbarHeight: 0,
                bottom: TabBar(
                  onTap: (index) {
                    setState(() {
                      tab_selected = index;
                    });
                  },
                  tabs: const [
                    Tab(
                      child: Text('Patient',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    Tab(
                      child: Text('History',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ],
                )),
            body: tab_selected == 0 ? patientRecord() : historyRecord()));
  }

  Widget patientRecord() {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.person_add,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const CreatePatient(),
          ));
        },
      ),
      body: getPatients(),
    );
  }

  Widget getPatients() {
    return FutureBuilder(
      future: patient.get(),
      builder: (context, AsyncSnapshot<List> snapshot) {
        final connectionDone = snapshot.connectionState == ConnectionState.done;
        if (connectionDone && snapshot.hasData) {
          final patients = snapshot.data!;
          return ListView.builder(
              padding: const EdgeInsets.all(5),
              itemCount: patients.length,
              itemBuilder: (context, index) {
                final patient = patients[index];
                return Card(
                  color: const Color.fromARGB(255, 250, 247, 237),
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(5),
                    minLeadingWidth: 0,
                    leading: const CircleAvatar(
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        radius: 25,
                        backgroundColor: Colors.greenAccent),
                    title: Text(
                      patient['fullname'].toString(),
                      style: const TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 17,
                          color: Colors.black),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => Profile(
                              id: patient['_id'],
                              fullname: patient['fullname'],
                              age: patient['age'],
                              illness: patient['illness'],
                              gender: patient['gender']),
                        ),
                      );
                    },
                  ),
                );
              });
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget historyRecord() {
    return ListView(
      children: const [
        Card(
          child: Text('history'),
        )
      ],
    );
  }

  Widget medicineScreen() {
    return ListView();
  }
}
