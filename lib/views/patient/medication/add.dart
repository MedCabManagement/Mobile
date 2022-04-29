import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:patient/models/medicine/medicine.dart';
import 'package:patient/models/medicine/medicineInfo.dart';
import 'package:patient/models/patient/patient.dart';

class AddMedication extends StatefulWidget {
  final String token, id;
  const AddMedication(this.token, this.id, {Key? key}) : super(key: key);

  @override
  State<AddMedication> createState() => _AddMedicationState();
}

class _AddMedicationState extends State<AddMedication> {
  final medicine = Medicine();

  final patient = Patient();

  List med_ids = [];

  List med_names = [];

  String selectval = "";

  bool visible = false;

  Future<List> fetchData() async {
    final url = Uri.https("medcab-rrc.herokuapp.com", "/medicines");

    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: ContentType.json.toString(),
      HttpHeaders.acceptHeader: ContentType.json.toString(),
      HttpHeaders.authorizationHeader: "Bearer ${widget.token.toString()}"
    };

    final response = await http.get(url, headers: headers);

    final data = jsonDecode(response.body) as List<dynamic>;

    List<dynamic> meds = data.map((e) => MedicineInfo.fromJson(e)).toList();

    for (int i = 0; i < meds.length; i++) {
      med_ids.add(meds[i].id);
      med_names.add(meds[i].name);
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text("Medicine"),
      ),
      body: ListView(
        children: [
          Container(
              margin: const EdgeInsets.all(45),
              child: FutureBuilder<List>(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    selectval = med_ids[0];
                    return DropdownButtonFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          filled: true,
                          fillColor: Color.fromARGB(255, 247, 247, 247)),
                      value: selectval,
                      onChanged: (newValue) {
                        setState(() {
                          selectval = newValue.toString();
                          med_ids[0] = selectval;
                          visible = true;
                        });
                      },
                      items: snapshot.data!.map((items) {
                        return DropdownMenuItem(
                          child: Text(items["name"]),
                          value: items["_id"],
                        );
                      }).toList(),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              )),
          Container(
              padding: const EdgeInsets.all(20),
              height: 200,
              width: 10,
              child: FutureBuilder(
                future:
                    medicine.getMedicine(selectval, widget.token.toString()),
                builder: (context, AsyncSnapshot snapshot) {
                  final connectionDone =
                      snapshot.connectionState == ConnectionState.done;
                  if (connectionDone && snapshot.hasData) {
                    final medications = snapshot.data!;

                    return Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        tileColor: Colors.blue[50],
                        contentPadding: const EdgeInsets.all(30),
                        title: Text(medications["name"].toString(),
                            style: const TextStyle(
                                color: Color.fromARGB(221, 237, 121, 121),
                                fontWeight: FontWeight.bold,
                                fontFamily: "OpenSans")),
                        subtitle: ListTile(
                          leading: Text(
                            medications["container"].toString(),
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold),
                          ),
                          title: Text(
                            medications["_id"].toString(),
                            style: const TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(medications["quantity"].toString(),
                              style: const TextStyle(color: Colors.blueGrey)),
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              )),
          const SizedBox(height: 30),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        child: Visibility(
            visible: visible,
            child: TextButton(
              onPressed: () async {
                final statusCode = await patient.addMedication(widget.id, selectval, widget.token);

                print(statusCode);
              },
              child: const Text("ADD MEDICINE", style: TextStyle(color: Colors.white)),
            )),
      ),
    );
  }
}
