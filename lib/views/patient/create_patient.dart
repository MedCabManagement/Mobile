import 'package:flutter/material.dart';
import 'package:patient/models/patient.dart';

class CreatePatient extends StatefulWidget {
  const CreatePatient({Key? key}) : super(key: key);

  @override
  State<CreatePatient> createState() => _CreatePatientState();
}

class _CreatePatientState extends State<CreatePatient> {
  final fullnameController = TextEditingController();
  final ageController = TextEditingController();
  final illnessController = TextEditingController();

  final patient = Patient();

  var textStyle = const TextStyle(
      fontFamily: 'OpenSans', fontSize: 17, fontWeight: FontWeight.bold);

  String genderValue = "Male";
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = const [
      DropdownMenuItem(child: Text("Male"), value: "Male"),
      DropdownMenuItem(child: Text("Female"), value: "Female"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text('Create'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(10, 60, 10, 20),
        children: [
          TextField(
            controller: fullnameController,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              labelText: "Fullname",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: ageController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Age",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: illnessController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Illness",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
          ),
          const SizedBox(height: 15),
          DropdownButtonFormField(
            decoration: const InputDecoration(
                labelText: "Gender",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            value: genderValue,
            onChanged: (String? newValue) {
              setState(() {
                genderValue = newValue!;
              });
            },
            items: dropdownItems,
          ),
          const SizedBox(height: 50),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(primary: Colors.green),
            onPressed: () async {
              final fullname = fullnameController.text;
              final age = ageController.text;
              final illness = illnessController.text;

              final disPatient =
                  await patient.create(fullname, age, illness, genderValue);

              if (disPatient == 200) {
                fullnameController.clear();
                ageController.clear();
                illnessController.clear();
                setState(() {
                  genderValue = "Male";
                });
              }
            },
            icon: const Icon(Icons.send),
            label: const Text('Create'),
          )
        ],
      ),
    );
  }
}
