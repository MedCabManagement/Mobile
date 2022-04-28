import 'package:flutter/material.dart';
import 'package:patient/models/medicine/medicine.dart';
import 'package:patient/models/user.dart';
import 'package:patient/views/medicine/list.dart';

class CreateMedicine extends StatefulWidget {
  final User user;
  const CreateMedicine(this.user, {Key? key}) : super(key: key);

  @override
  State<CreateMedicine> createState() => _CreateMedicineState();
}

class _CreateMedicineState extends State<CreateMedicine> {
  int selected_screen = 0;
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final containerController = TextEditingController();
  final quantityController = TextEditingController();

  final medicine = Medicine();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        bottomNavigationBar: BottomAppBar(
          color: const Color.fromARGB(255, 51, 118, 56),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ))),
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextButton(
                      onPressed: () async {
                        final name = nameController.text;
                        final container = containerController.text;
                        final quantity = quantityController.text;

                        if (_formKey.currentState!.validate()) {
                          final statusCode = await medicine.post(
                              name,
                              int.parse(quantity),
                              int.parse(container),
                              widget.user.token.toString());
                          if (statusCode == 200) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MedicineList(widget.user)));
                          }
                        }
                      },
                      child: const Text("Save",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16)))),
              const Spacer(),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(10, 45, 10, 20),
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) return "Enter Field Name";
                },
                controller: nameController,
                maxLength: 30,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: "Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
              const SizedBox(height: 10),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Field Container";
                  } else if (int.parse(value) > 5 || int.parse(value) == 0) {
                    return "Enter only 1-5 container";
                  }
                  ;
                },
                controller: containerController,
                keyboardType: TextInputType.number,
                maxLength: 1,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.numbers_outlined),
                    hintText: "Container",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
              const SizedBox(height: 10),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Field Quantity";
                  } else if (double.tryParse(value) == null) {
                    return "Enter number only";
                  }
                },
                controller: quantityController,
                keyboardType: TextInputType.number,
                maxLength: 3,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.numbers),
                    hintText: "Quantity",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ],
          ),
        ));
  }
}
