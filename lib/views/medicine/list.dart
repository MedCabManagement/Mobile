import 'package:flutter/material.dart';
import 'package:patient/models/medicine/medicine.dart';
import 'package:patient/models/user.dart';
import 'package:patient/views/home.dart';
import 'package:patient/views/medicine/create.dart';

class MedicineList extends StatefulWidget {
  final User user;
  const MedicineList(this.user, {Key? key}) : super(key: key);

  @override
  State<MedicineList> createState() => _MedicineListState();
}

class _MedicineListState extends State<MedicineList> {

  final medicine = Medicine();
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
        title: const Text("Medicines"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CreateMedicine(widget.user),
          ));
        },
      ),
      body: getMedicines(),
    );
  }

  Widget getMedicines() {
    return FutureBuilder(
      future: medicine.get(widget.user.token.toString()),
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
                  color: const Color.fromARGB(255, 196, 234, 243),
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(20,5,5,5),
                    minLeadingWidth: 0,
                    leading: Text(
                      patient['name'].toString(),
                      style: const TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 17,
                          color: Colors.black),
                    ),
                    onTap: () async {
                      // final _dispatient = await _patient.getPatient(
                      //     patient['_id'], widget.user.token.toString());

                      // Navigator.of(context).push(MaterialPageRoute(
                      //   builder: (BuildContext context) => Profile(
                      //     id: patient['_id'],
                      //     name: patient['name'],
                      //     age: patient['age'],
                      //     token: widget.user.token.toString(),
                      //   ),
                      // ));
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
