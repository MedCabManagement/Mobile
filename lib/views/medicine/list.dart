import 'package:flutter/material.dart';
import 'package:patient/models/medicine.dart';
import 'package:patient/models/user.dart';

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
        automaticallyImplyLeading: true,
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text("Medicine List"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
        onPressed: () {
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => CreatePatient(widget.user),
          // ));
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
                  color: Color.fromARGB(255, 237, 241, 242),
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(5),
                    minLeadingWidth: 0,
                    leading: const CircleAvatar(
                        child: Icon(
                          Icons.medication_liquid,
                          color: Colors.green,
                        ),
                        radius: 15,
                        backgroundColor: Colors.white),
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
