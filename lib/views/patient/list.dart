import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient/models/patient.dart';
import 'package:patient/models/user.dart';
import 'package:patient/views/patient/Profile.dart';
import 'package:patient/views/patient/create.dart';
import 'package:patient/views/home.dart';

class PatientList extends StatefulWidget {
  final User user;
  const PatientList(this.user, {Key? key}) : super(key: key);

  @override
  State<PatientList> createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  final _patient = Patient();

  bool onTapPressed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: TextButton(
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(widget.user),
              ),
            );
          },
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text("Patient List"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.person_add,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CreatePatient(widget.user),
          ));
        },
      ),
      body: getPatients(),
    );
  }

  Widget getPatients() {
    return FutureBuilder(
      future: _patient.get(widget.user.token.toString()),
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
                      patient['name'].toString(),
                      style: const TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 17,
                          color: Colors.black),
                    ),
                    onTap: () async {
                      // final _dispatient = await _patient.getPatient(
                      //     patient['_id'], widget.user.token.toString());

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => Profile(
                            id: patient['_id'],
                            name: patient['name'],
                            age: patient['age'],
                            token: widget.user.token.toString(),
                          ),
                        ));
                      
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
}
