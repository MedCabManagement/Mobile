import 'package:flutter/material.dart';
import 'package:patient/models/patient/patient.dart';
import 'package:patient/models/user.dart';
import 'package:patient/theme/theme.dart';
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

  bool visible = true;
  bool valuefirst = false;

  refresh() {
    return _patient.get(widget.user.token.toString());
  }

  Future<void> refreshList() async {
    await Future.delayed(const Duration(milliseconds: 0));
    setState(() {
      refresh();
    });
  }

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
        backgroundColor: CustomColors.customGreen,
        centerTitle: true,
        title: const Text("Patients"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.person_add,
          color: Colors.white,
        ),
        backgroundColor: CustomColors.customGreen,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CreatePatient(widget.user),
          ));
        },
      ),
      body: RefreshIndicator(
        onRefresh: refreshList,
        child: getPatients(),
      ),
    );
  }

  Widget getPatients() {
    return FutureBuilder(
      future: _patient.get(widget.user.token.toString()),
      builder: (context, AsyncSnapshot<List> snapshot) {
        final connectionDone = snapshot.connectionState == ConnectionState.done;
        if (connectionDone && snapshot.hasData) {
          final patients = snapshot.data!;

          if (patients.isEmpty) {
            return const Center(
              child: Text("Empty",
                  style: TextStyle(fontSize: 16, color: Colors.black)),
            );
          }
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
                    trailing: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 17,
                              color: Colors.black,
                            )
                          ],
                        )),
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
                          name: patient['name'].toString(),
                          age: patient['age'],
                          user: widget.user,
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
