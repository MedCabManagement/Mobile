import 'package:flutter/material.dart';
import 'package:patient/models/patient/patient.dart';
import 'package:patient/models/user.dart';
import 'package:patient/views/patient/list.dart';

class CreatePatient extends StatefulWidget {
  final User user;
  const CreatePatient(this.user, {Key? key}) : super(key: key);

  @override
  State<CreatePatient> createState() => _CreatePatientState();
}

class _CreatePatientState extends State<CreatePatient> {
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  final patient = Patient();
  final _formKey = GlobalKey<FormState>();

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
        title: const Text('Create'),
      ),
      body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(10, 60, 10, 20),
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Please Enter Name";
                },
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) return "Please Enter Age";
                },
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Age",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final name = nameController.text;
                    final age = int.parse(ageController.text);
                    final disPatient = await patient.create(
                        name, age, widget.user.token.toString());

                    if (disPatient == 200) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PatientList(widget.user)));
                    }
                  }
                },
                icon: const Icon(Icons.send),
                label: const Text('Create'),
              )
            ],
          )),
    );
  }
}
