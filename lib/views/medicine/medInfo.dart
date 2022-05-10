import 'package:flutter/material.dart';
import 'package:patient/models/medicine/medicine.dart';
import 'package:patient/models/user.dart';
import 'package:patient/views/medicine/list.dart';

class MedInfo extends StatefulWidget {
  final String id, name;
  final int quantity, container;
  final User user;
  const MedInfo(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.container,
      required this.user,
      Key? key})
      : super(key: key);

  @override
  State<MedInfo> createState() => _MedInfoState();
}

class _MedInfoState extends State<MedInfo> {
  final medicine = Medicine();

  bool _enable = false;
  bool _editIcon = true;
  bool _checkIcon = false;

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final containerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (idController.text == "" &&
        nameController.text == "" &&
        quantityController.text == "" &&
        containerController.text == "") {
      idController.text = widget.id;
      nameController.text = widget.name;
      quantityController.text = widget.quantity.toString();
      containerController.text = widget.container.toString();
    }
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text("Medicine Info"),
        leading: TextButton(
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MedicineList(widget.user),
              ),
            );
          },
        ),
        actions: [
          Visibility(
            visible: _editIcon,
            child: TextButton(
              child: const Icon(Icons.edit,
                  size: 25, color: Color.fromARGB(255, 21, 62, 101)),
              onPressed: () async {
                setState(() {
                  _editIcon = false;
                  _checkIcon = true;
                  _enable = true;
                });
              },
            ),
          ),
          Visibility(
            visible: _checkIcon,
            child: TextButton(
              child: const Text("SAVE",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 14)),
              onPressed: () async {
                final disName = nameController.text;
                final disQuantity = quantityController.text;
                final disContainer = containerController.text;

                final statusCode = await medicine.edit(
                    widget.id,
                    disName,
                    int.parse(disQuantity),
                    int.parse(disContainer),
                    widget.user.token.toString());

                if (statusCode == 200) {
                  setState(() {
                    _enable = false;
                    _editIcon = true;
                    _checkIcon = false;
                  });
                }
              },
            ),
          ),
        ],
      ),
      body: Container(
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            const SizedBox(height: 15),
            const Text("Id",
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontFamily: "OpenSans")),
            const SizedBox(height: 10),
            TextField(
              controller: idController,
              enabled: false,
              decoration: InputDecoration(
                fillColor: Colors.green[100],
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
              ),
            ),
            const SizedBox(height: 15),
            const Text("Name",
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontFamily: "OpenSans")),
            const SizedBox(height: 15),
            TextField(
              controller: nameController,
              enabled: _enable,
              decoration: InputDecoration(
                fillColor: Colors.green[100],
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
              ),
            ),
            const SizedBox(height: 15),
            const Text("Quantity",
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontFamily: "OpenSans")),
            const SizedBox(height: 15),
            TextField(
              controller: quantityController,
              enabled: _enable,
              decoration: InputDecoration(
                fillColor: Colors.green[100],
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
              ),
            ),
            const SizedBox(height: 15),
            const Text("Container",
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                    fontFamily: "OpenSans")),
            const SizedBox(height: 15),
            TextField(
              controller: containerController,
              enabled: _enable,
              decoration: InputDecoration(
                fillColor: Colors.green[100],
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: TextButton.icon(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label:
                      const Text("Remove", style: TextStyle(color: Colors.red)),
                  onPressed: () async {
                    final statusCode = await medicine.delete(
                        widget.id, widget.user.token.toString());

                    if (statusCode == 200) {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedicineList(widget.user),
                        ),
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
