import 'package:flutter/material.dart';
import 'package:patient/models/medication/medication.dart';
import 'package:patient/models/patient/patient.dart';
import 'package:patient/models/schedule/schedule.dart';
import 'package:patient/models/user.dart';
import 'package:patient/views/patient/medication/schedules/view.dart';

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
                      builder: (context) => AddSchedule(
                          widget.token, widget.medication.id.toString())));
                },
                child: const Icon(
                  Icons.add,
                  size: 26.0,
                ),
              )),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                      color: const Color.fromARGB(255, 109, 178, 227)),
                ),
                height: 380,
                child: FutureBuilder(
                  future: patient.getOneMedication(
                      widget.id, widget.medication.id.toString(), widget.token),
                  builder: (context, AsyncSnapshot<List<Schedule>> snapshot) {
                    final connectionDone =
                        snapshot.connectionState == ConnectionState.done;
                    if (connectionDone && snapshot.hasData) {
                      final schedules = snapshot.data!;
                      // print(schedules);
                      return ListView.builder(
                          padding: const EdgeInsets.all(5),
                          itemCount: schedules.length,
                          itemBuilder: (context, index) {
                            final schedule = schedules[index];
                            return Card(
                              color: const Color.fromARGB(255, 250, 247, 237),
                              elevation: 20,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: ListTile(
                                minLeadingWidth: 0,
                                title: Text(schedule.getTimeString()),
                                subtitle: Text(
                                  schedule.days?.join(", ") ?? "",
                                  style: const TextStyle(
                                      fontFamily: "OpenSans",
                                      color: Colors.black),
                                ),
                                onTap: () {
                                  // final _dispatient = await _patient.getPatient(
                                  //     patient['_id'], widget.user.token.toString());
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
              )),
        ],
      ),
    );
  }
}
