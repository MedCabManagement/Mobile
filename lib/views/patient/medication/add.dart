import 'package:flutter/material.dart';
import 'package:patient/models/medicine/medicine.dart';

class AddMedication extends StatefulWidget {
  final String token;
  const AddMedication(this.token, {Key? key}) : super(key: key);

  @override
  State<AddMedication> createState() => _AddMedicationState();
}

class _AddMedicationState extends State<AddMedication> {

  final medicine = Medicine();
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
          FutureBuilder(
            future: medicine.get(widget.token),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                
              }
            },
          )
        ],
      ),
    );
  }
}
