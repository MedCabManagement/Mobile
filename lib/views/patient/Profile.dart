import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:patient/models/medication/medication.dart';
import 'package:patient/models/medicine/medicineInfo.dart';
import 'package:patient/models/patient/patient.dart';
import 'package:patient/models/user.dart';
import 'package:patient/views/home.dart';
import 'package:patient/views/patient/list.dart';
import 'package:patient/views/patient/medication/add.dart';
import 'package:patient/views/patient/medication/view.dart';

class Profile extends StatefulWidget {
  final String name, id;
  final User user;
  final int age;
  const Profile(
      {required this.id,
      required this.name,
      required this.age,
      required this.user,
      Key? key})
      : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final patient = Patient();

  final nameController = TextEditingController();
  final ageController = TextEditingController();

  bool _enable = false;
  bool _dots = true;

  bool _checkIcon = false;

  getMedications() {
    return patient.getMedications(widget.id, widget.user.token.toString());
  }

  Future<void> refreshList() async {
    await Future.delayed(const Duration(milliseconds: 0));
    setState(() {
      getMedications();
    });
  }

  showAlertDialog(BuildContext context, medID) {
    Widget okButton = FlatButton(
      child: const Text(
        "Yes",
        style: TextStyle(color: Colors.green),
      ),
      onPressed: () async {
        final statusCode = await patient.deleteMedication(
            widget.id, medID, widget.user.token.toString());

        if (statusCode == 200) {
          Navigator.pop(context);
          setState(() {
            getMedications();
          });
        }
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirmation"),
      content: const Text("Are you sure you want to remove this medication?",
          style: TextStyle(color: Colors.red)),
      actions: [okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (ageController.text == "" && ageController.text == "") {
      ageController.text = widget.age.toString();
      nameController.text = widget.name.toString();
    }

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
                builder: (context) => PatientList(widget.user),
              ),
            );
          },
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text('Profile'),
        actions: [
          Visibility(
            visible: _checkIcon,
            child: TextButton(
              child: const Icon(Icons.check, size: 35, color: Colors.blue),
              onPressed: () async {
                final disName = nameController.text;
                final disAge = ageController.text;

                final statusCode = await patient.edit(widget.id, disName,
                    int.parse(disAge), widget.user.token.toString());
                if (statusCode == 200) {
                  setState(() {
                    _checkIcon = false;
                    _dots = true;
                    _enable = false;
                  });
                }
              },
            ),
          ),
          Visibility(
            visible: _dots,
            child: TextButton(
              onPressed: () {
                showMenu(
                    context: context,
                    position: const RelativeRect.fromLTRB(100, 70, 10, 20),
                    color: Colors.white70,
                    items: [
                      PopupMenuItem(
                          onTap: () {
                            setState(() {
                              _dots = false;
                              _checkIcon = true;
                              _enable = true;
                            });
                          },
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                ),
                                TextSpan(
                                  text: "   Edit",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      PopupMenuItem<String>(
                          onTap: () async {
                            final statusCode = await patient.delete(
                                widget.id, widget.user.token.toString());

                            if (statusCode == 200) {
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PatientList(widget.user),
                                ),
                              );
                            }
                          },
                          child: RichText(
                            text: const TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                                TextSpan(
                                  text: "   Delete",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ]);
              },
              child: const Icon(Icons.more_horiz, color: Colors.black),
            ),
          ),
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
                    onPressed: () =>
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => AddMedication(
                              widget.id, widget.name, widget.age, widget.user),
                        )),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ))),
            const Spacer(),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshList,
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            const SizedBox(height: 10),
            const Text("Name",
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontFamily: "OpenSans")),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              enabled: _enable,
              decoration: InputDecoration(
                fillColor: Colors.green[100],
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
            ),
            const SizedBox(height: 5),
            const Text("Age",
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontFamily: "OpenSans")),
            const SizedBox(height: 10),
            TextField(
              controller: ageController,
              enabled: _enable,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
              ),
            ),
            // Card(
            //     elevation: 3,
            //     color: Colors.green[100],
            //     child: ListTile(
            //       contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            //       leading: Text(widget.age.toString(),
            //           style: const TextStyle(fontSize: 17)),
            //     )),
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
              height: 360,
              child: getMed(),
            ),
          ],
        ),
      ),
    );
  }

  Widget getMed() {
    return FutureBuilder(
      future: getMedications(),
      builder: (context, AsyncSnapshot<List<Medication>> snapshot) {
        final connectionDone = snapshot.connectionState == ConnectionState.done;
        if (connectionDone && snapshot.hasData) {
          final medications = snapshot.data!;
          if (medications.isEmpty) {
            return const Center(
              child: Text("Empty",
                  style: TextStyle(fontSize: 16, color: Colors.black)),
            );
          }
          return ListView.builder(
              padding: const EdgeInsets.all(5),
              itemCount: medications.length,
              itemBuilder: (context, index) {
                final medication = medications[index];
                // print(medication.id.toString());
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
                    onTap: () {
                      Navigator.of(context)
                          .popUntil((route) => Navigator.of(context).canPop());
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ViewMeds(medication, widget.id,
                            widget.user.token.toString()),
                      ));
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            size: 18.0,
                            color: Colors.red[900],
                          ),
                          onPressed: () {
                            showAlertDialog(context, medication.id);
                          },
                        ),
                      ],
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
