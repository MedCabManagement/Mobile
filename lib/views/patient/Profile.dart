import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:patient/models/medication/medication.dart';
import 'package:patient/models/medicine/medicineInfo.dart';
import 'package:patient/models/patient/patient.dart';
import 'package:patient/views/home.dart';
import 'package:patient/views/patient/medication/add.dart';

class Profile extends StatefulWidget {
  final String name, id, token;
  final int age;
  const Profile(
      {required this.id,
      required this.name,
      required this.age,
      required this.token,
      Key? key})
      : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final patient = Patient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text('Profile'),
        actions: [
          TextButton(
              onPressed: () {},
              child: const Icon(Icons.edit, color: Colors.black))
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey,
        child: Row(
          children: [
            const Spacer(),
            Padding(
                padding: const EdgeInsets.all(5),
                child: TextButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => AddMedication(widget.token),
                        )),
                    child: const Icon(Icons.add, color: Colors.white,))),
                    
            const Spacer(),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          const SizedBox(height: 10),
          const Text("Name",
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontFamily: "OpenSans")),
          Card(
              elevation: 3,
              color: Colors.green[100],
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                leading:
                    Text(widget.name, style: const TextStyle(fontSize: 17)),
              )),
          const SizedBox(height: 5),
          const Text("Age",
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontFamily: "OpenSans")),
          const SizedBox(height: 10),
          Card(
              elevation: 3,
              color: Colors.green[100],
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                leading: Text(widget.age.toString(),
                    style: const TextStyle(fontSize: 17)),
              )),
          const SizedBox(height: 15),
          const Center(
              child: Text("Medication",
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontFamily: "OpenSans"))),
          Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15),
              border:
                  Border.all(color: const Color.fromARGB(255, 109, 178, 227)),
            ),
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            height: 350,
            child: getMed(),
          ),
        ],
      ),
    );
  }

  Widget getMed() {
    return FutureBuilder(
      future: patient.getMedication(widget.id, widget.token),
      builder: (context, AsyncSnapshot<List<Medication>> snapshot) {
        final connectionDone = snapshot.connectionState == ConnectionState.done;
        if (connectionDone && snapshot.hasData) {
          final medications = snapshot.data!;
          return ListView.builder(
              padding: const EdgeInsets.all(5),
              itemCount: medications.length,
              itemBuilder: (context, index) {
                final medication = medications[index];
                return Card(
                  color: const Color.fromARGB(255, 250, 247, 237),
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: ListTile(
                    minLeadingWidth: 0,
                    leading: Text(
                      medication.medicine.name.toString(),
                      style: const TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 17,
                          color: Colors.black),
                    ),
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
}
