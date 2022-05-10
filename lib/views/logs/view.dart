import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:patient/models/Log/log.dart';
import 'package:patient/models/user.dart';

class Logs extends StatefulWidget {
  final User user;
  const Logs(this.user, {Key? key}) : super(key: key);

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text("Logs"),
      ),
      body: FutureBuilder(
        future: () async {
          final url = Uri.https("medcab-rrc.herokuapp.com", "/logs");
          final String token = widget.user.token.toString();

          final headers = <String, String>{
            HttpHeaders.contentTypeHeader: ContentType.json.toString(),
            HttpHeaders.acceptHeader: ContentType.json.toString(),
            HttpHeaders.authorizationHeader: "Bearer $token"
          };

          final response = await http.get(url, headers: headers);

          final data = jsonDecode(response.body);

          return (data as List<dynamic>)
              .map((log) => Log(
                  patientID: log['patientId'],
                  medicineName: log['medicineName'],
                  schedule: log['schedule'],
                  status: log['status']))
              .toList();
        }(),
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
                      leading: Text(
                        log.patientID.toString(),
                        style: const TextStyle(
                            fontFamily: "OpenSans",
                            fontSize: 17,
                            color: Colors.black),
                      ),
                      title: ListTile(
                        title: Text(log.medicineName.toString()),
                        subtitle: Text(log.schedule.toString()),
                      ),
                      subtitle: Text(log.status.toString()),
                      onTap: () async {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (BuildContext context) => MedInfo(
                        //       id: medicine['_id'],
                        //       name: medicine['name'],
                        //       quantity: medicine['quantity'],
                        //       container: medicine['container'],
                        //       user: widget.user),
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
      ),
    );
  }
}
