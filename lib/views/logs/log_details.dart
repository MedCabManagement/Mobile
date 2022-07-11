

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient/theme/theme.dart';
import 'package:patient/views/logs/thermal_print.dart';


class LogDetailsView extends StatefulWidget {

  final String id;
  final String medicationId;
  final String patientID;
  final String patientName;
  final String medicineId;
  final String medicineName;
  final String schedule;
  final String status;
  const LogDetailsView(
      {Key? key,
      required this.id,
      required this.medicationId,
      required this.patientID,
      required this.patientName,
      required this.medicineId,
      required this.medicineName,
      required this.schedule,
      required this.status})
      : super(key: key);

  @override
  State<LogDetailsView> createState() => _LogDetailsViewState();
}
  _verticalDivider() {
    return const VerticalDivider(
      color: Colors.white,
      width: 1,
      thickness: 1,
    );
  }

class _LogDetailsViewState extends State<LogDetailsView> {


  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(style: BorderStyle.solid, width: 1),
      color: Colors.white60
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.customGreen,
        title: const Text('View Log'),
        centerTitle: true,
        actions: [

          IconButton(
              onPressed: () => {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => ThermalPrint(
                              id: widget.id,
                              medicationId: widget.medicationId,
                              patientID: widget.patientID,
                              patientName: widget.patientName,
                              medicineId: widget.medicineId,
                              medicineName: widget.medicineName,
                              schedule: widget.schedule,
                              status: widget.status,
                            )))
                  },
              icon: const Icon(
                Icons.print,
                size: 24,
              )),
          
        ],
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.fromLTRB(20, 70, 40, 70),
        height: 700,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(flex: 1, child: Text('ID: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue, fontSize: 15),)),
                _verticalDivider(),
                const Expanded(flex: 1, child: Text('Medication ID: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue, fontSize: 15))),
                _verticalDivider(),
                const Expanded(flex: 1, child: Text('Patient ID: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue, fontSize: 15))),
                _verticalDivider(),
                const Expanded(flex: 1, child: Text('Patient Name: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue, fontSize: 15))),
                _verticalDivider(),
                const Expanded(flex: 1, child: Text('Medicine ID: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue, fontSize: 15))),
                _verticalDivider(),
                const Expanded(flex: 1, child: Text('Medicine Name: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue, fontSize: 15))),
                _verticalDivider(),
                const Expanded(flex: 1, child: Text('Schedule: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue, fontSize: 15))),
                _verticalDivider(),
                const Expanded(flex: 1, child: Text('Status: ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.lightBlue, fontSize: 15))),
                _verticalDivider(),
              ],
            ),

            const Spacer(),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 1, child: Text(widget.id)),
                _verticalDivider(),
                Expanded(flex: 1, child: Text(widget.medicationId)),
                _verticalDivider(),
                Expanded(flex: 1, child: Text(widget.patientID)),
                _verticalDivider(),
                Expanded(flex: 1, child: Text(widget.patientName)),
                _verticalDivider(),
                Expanded(flex: 1, child: Text(widget.medicineId)),
                _verticalDivider(),
                Expanded(flex: 1, child: Text(widget.medicineName)),
                _verticalDivider(),
                Expanded(flex: 1, child: Text(widget.schedule)),
                _verticalDivider(),
                Expanded(flex: 1, child: Text(widget.status, style: TextStyle(color: widget.status.toString() == 'Success' ? Colors.green : Colors.red),),),
                _verticalDivider(),
              ],
            )
          ],
        ),
      ),
    );
    
  }

}