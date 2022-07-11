import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:patient/models/Log/log.dart';
import 'package:patient/models/user.dart';
import 'package:patient/theme/theme.dart';
import 'package:patient/views/logs/log_details.dart';

class Logs extends StatefulWidget {
  final User user;
  const Logs(this.user, {Key? key}) : super(key: key);

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  final log = Log();

  fetch() {
    return log.refresh(widget.user.token.toString());
  }

  Future<void> refreshList() async {
    await Future.delayed(const Duration(milliseconds: 0));
    setState(() {
      fetch();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: CustomColors.customGreen,
        centerTitle: true,
        title: const Text("Logs"),
      ),
      body: RefreshIndicator(
        onRefresh: refreshList,
        child: FutureBuilder(
        future: fetch(),
        builder: (context, AsyncSnapshot<List<Log>> snapshot) {
          final connectionDone =
              snapshot.connectionState == ConnectionState.done;
          if (connectionDone && snapshot.hasData) {
            final logs = snapshot.data!;

            if (logs.isEmpty) {
              return const Center(
                child: Text("Empty",
                    style: TextStyle(fontSize: 16, color: Colors.black)),
              );
            }

            return ListView.builder(
                padding: const EdgeInsets.all(5),
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];

                  String date = log.schedule.toString();
                  DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(date);
                  var inputDate = DateTime.parse(parseDate.toString());
                  var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
                  var outputDate = outputFormat.format(inputDate);
                  
               
                  return Card(
                    color: const Color.fromARGB(255, 190, 228, 236),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      trailing: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 17,
                                color: Colors.black,
                              )
                            ],
                          )),
                      contentPadding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
                      minLeadingWidth: 0,
                      title: Text(
                        log.id.toString(),
                        style: const TextStyle(
                            fontFamily: "OpenSans",
                            fontSize: 17,
                            color: Colors.black),
                      ),
                      subtitle: Text(outputDate.toString()),
                      onTap: () async {

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => LogDetailsView(
                              id: log.id.toString(),
                              medicationId: log.medicationId.toString(),
                              patientID: log.patientID.toString(),
                              patientName: log.patientName.toString(),
                              medicineId: log.medicineId.toString(),
                              medicineName: log.medicineName.toString(),
                              schedule: outputDate,
                              status: log.status.toString(),
                      
                        )));
                      },
                    ),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
    );
  }
}
