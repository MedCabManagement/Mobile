import 'package:flutter/material.dart';
import 'package:patient/models/medication/medication.dart';
import 'package:patient/models/patient/patient.dart';
import 'package:patient/models/schedule/schedule.dart';
import 'package:patient/views/patient/medication/schedules/add.dart';
import 'package:patient/views/patient/medication/schedules/edit.dart';
import 'dart:ui' show ImageFilter;

class ViewMeds extends StatefulWidget {
  final Medication medication;
  final String id, token;
  const ViewMeds(this.medication, this.id, this.token, {Key? key})
      : super(key: key);

  @override
  State<ViewMeds> createState() => _ViewMedsState();
}

class _ViewMedsState extends State<ViewMeds> {
  final patient = Patient();
  // var keyRefresh = GlobalKey<RefreshIndicatorState>();

  List<String> store_days = [];

  refresh() {
    return patient.getOneMedication(
        widget.id, widget.medication.id.toString(), widget.token);
  }

  Future<void> refreshList() async {
    await Future.delayed(const Duration(milliseconds: 0));
    setState(() {
      refresh();
    });
  }

  showAlertDialog(BuildContext context, schedID) {
    Widget okButton = FlatButton(
      child: const Text(
        "Yes",
        style: TextStyle(color: Colors.green),
      ),
      onPressed: () async {
        final statusCode = await patient.deleteSchedule(
            widget.id, widget.medication.id.toString(), schedID, widget.token);
        if (statusCode == 200) {
          Navigator.pop(context);
          setState(() {
            refresh();
          });
        }
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Confirmation"),
      content: const Text("Are you sure you want to delete?",
          style: TextStyle(color: Colors.red)),
      actions: [okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: const Text("Medication"),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .popUntil((route) => Navigator.of(context).canPop());
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddSchedule(widget.id,
                            widget.token, widget.medication.id.toString())));
                  },
                  child: const Icon(
                    Icons.add,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: refreshList,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: FlatButton(
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: const Color(0xFFF5F6F9),
                  onPressed: () {},
                  child: Row(
                    children: [
                      const Text("Medication ID : ",
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      Expanded(
                          child: Text(
                        widget.medication.id.toString(),
                        style: Theme.of(context).textTheme.bodyText1,
                      )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: FlatButton(
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: const Color(0xFFF5F6F9),
                  onPressed: () {},
                  child: Row(
                    children: [
                      const Text("Name : ",
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      Expanded(
                          child: Text(
                        widget.medication.medicine.name.toString(),
                        style: Theme.of(context).textTheme.bodyText1,
                      )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: FlatButton(
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: const Color(0xFFF5F6F9),
                  onPressed: () {},
                  child: Row(
                    children: [
                      const Text("Container : ",
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      Expanded(
                          child: Text(
                        widget.medication.medicine.container.toString(),
                        style: Theme.of(context).textTheme.bodyText1,
                      )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: FlatButton(
                  padding: const EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: const Color(0xFFF5F6F9),
                  onPressed: () {},
                  child: Row(
                    children: [
                      const Text("Quantity : ",
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      Expanded(
                          child: Text(
                        widget.medication.medicine.quantity.toString(),
                        style: Theme.of(context).textTheme.bodyText1,
                      ))
                    ],
                  ),
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: const Color.fromARGB(255, 109, 178, 227)),
                    ),
                    height: 500,
                    child: FutureBuilder(
                      future: refresh(),
                      builder:
                          (context, AsyncSnapshot<List<Schedule>> snapshot) {
                        final connectionDone =
                            snapshot.connectionState == ConnectionState.done;
                        if (connectionDone && snapshot.hasData) {
                          final schedules = snapshot.data!;

                          if (schedules.isEmpty) {
                            return const Center(
                              child: Text("Empty",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black)),
                            );
                          }
                          // print(schedules);
                          return ListView.builder(
                              padding: const EdgeInsets.all(5),
                              itemCount: schedules.length,
                              itemBuilder: (context, index) {
                                final schedule = schedules[index];
                                // print(schedule.days?.join(", "));
                                return Card(
                                  color:
                                      const Color.fromARGB(255, 250, 247, 237),
                                  elevation: 20,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: ListTile(
                                    minLeadingWidth: 0,
                                    title: Text(schedule.getTimeString(),
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                      schedule.days?.join(", ") ?? "",
                                      style: const TextStyle(
                                          fontFamily: "OpenSans",
                                          color: Colors.blueGrey,
                                          fontSize: 12),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(
                                            Icons.edit_outlined,
                                            size: 18.0,
                                            color: Colors.blue[900],
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).popUntil(
                                                (route) => Navigator.of(context)
                                                    .canPop());
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  EditSchedule(
                                                      schedule,
                                                      widget.id,
                                                      widget.medication,
                                                      widget.token),
                                            ));
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.delete_outline,
                                            size: 18.0,
                                            color: Colors.red[900],
                                          ),
                                          onPressed: () {
                                            BackdropFilter(
                                              filter: ImageFilter.blur(
                                                  sigmaX: 5.0, sigmaY: 5.0),
                                              child: showAlertDialog(
                                                  context, schedule.id),
                                            );
                                            ;
                                          },
                                        ),
                                      ],
                                    ),
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
                  )),
            ],
          ),
        ));
  }
}
