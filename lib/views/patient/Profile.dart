import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:patient/models/medicine.dart';
import 'package:patient/models/patient.dart';
import 'package:patient/views/home.dart';

class Profile extends StatefulWidget {
  final String name, id, token;
  final String medication;
  final int age;
  const Profile(
      {required this.id,
      required this.name,
      required this.age,
      required this.medication,
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
    print(widget.medication);
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
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          const SizedBox(height: 10),
          const Text("Name",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontFamily: "OpenSans")),
          Card(
              color: Colors.white60,
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                leading:
                    Text(widget.name, style: const TextStyle(fontSize: 17)),
              )),
          const SizedBox(height: 5),
          const Text("Age",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontFamily: "OpenSans")),
          Card(
              color: Colors.white60,
              child: ListTile(
                contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                leading: Text(widget.age.toString(),
                    style: const TextStyle(fontSize: 17)),
              )),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: Text(widget.medication),
            ),
          ),
          TextButton.icon(
              onPressed: () async {
                final res = await patient.delete(widget.id);

                if (res == 200) {
                  Navigator.pop(context, true);
                }
              },
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text("Delete", style: TextStyle(color: Colors.red)))
        ],
      ),
    );
  }
}
