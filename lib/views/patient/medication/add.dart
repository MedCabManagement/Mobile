import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:patient/models/medicine/medicine.dart';
import 'package:patient/models/medicine/medicineInfo.dart';

class AddMedication extends StatefulWidget {
  final String token;
  const AddMedication(this.token, {Key? key}) : super(key: key);

  @override
  State<AddMedication> createState() => _AddMedicationState();
}

class _AddMedicationState extends State<AddMedication> {
  final medicine = Medicine();

  List med_ids = [];

  List med_names = [];

  String selectval = "";

  String medicine_name = "";

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
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text("Add"),
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
                              Radius.circular(30.0),
                            ),
                          ),
                          filled: true,
                          fillColor: Color.fromARGB(255, 224, 230, 239)),
                      value: selectval,
                      onChanged: (newValue) {
                        setState(() {
                          selectval = newValue.toString();
                          med_ids[0] = selectval;
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
              height: 300,
              child: FutureBuilder(
                future:
                    medicine.getMedicine(selectval, widget.token.toString()),
                builder: (context, AsyncSnapshot snapshot) {
                  final connectionDone =
                      snapshot.connectionState == ConnectionState.done;
                  if (connectionDone && snapshot.hasData) {
                    final medications = snapshot.data!;
                    print(medications);
                    return Card(
                      child: ListTile(
                        leading: Text(medications["container"].toString()),
                        title: Text(medications["name"].toString()),
                        subtitle: Text(medications["_id"].toString()),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              )),
        ],
      ),
    );
  }
}
