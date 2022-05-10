import 'package:flutter/material.dart';
import 'package:patient/models/medicine/medicine.dart';
import 'package:patient/models/user.dart';
import 'package:patient/views/home.dart';
import 'package:patient/views/medicine/create.dart';
import 'package:patient/views/medicine/medInfo.dart';

class MedicineList extends StatefulWidget {
  final User user;
  const MedicineList(this.user, {Key? key}) : super(key: key);

  @override
  State<MedicineList> createState() => _MedicineListState();
}

class _MedicineListState extends State<MedicineList> {
  final medicine = Medicine();

  fetchMeds() {
    return medicine.get(widget.user.token.toString());
  }

  Future<void> refreshList() async {
    await Future.delayed(const Duration(milliseconds: 0));
    setState(() {
      fetchMeds();
    });
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
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(widget.user),
                ),
              );
            },
          ),
          backgroundColor: Colors.green,
          centerTitle: true,
          title: const Text("Medicines"),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.green,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CreateMedicine(widget.user),
            ));
          },
        ),
        body: RefreshIndicator(
          onRefresh: refreshList,
          child: getMedicines(),
        ));
  }

  Widget getMedicines() {
    return FutureBuilder(
      future: fetchMeds(),
      builder: (context, AsyncSnapshot<List> snapshot) {
        final connectionDone = snapshot.connectionState == ConnectionState.done;
        if (connectionDone && snapshot.hasData) {
          final medicines = snapshot.data!;

          if (medicines.isEmpty) {
            return const Center(
              child: Text("Empty",
                  style: TextStyle(fontSize: 16, color: Colors.black)),
            );
          }
          return ListView.builder(
              padding: const EdgeInsets.all(5),
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final medicine = medicines[index];
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
                      medicine['name'].toString(),
                      style: const TextStyle(
                          fontFamily: "OpenSans",
                          fontSize: 17,
                          color: Colors.black),
                    ),
                    onTap: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => MedInfo(
                            id: medicine['_id'],
                            name: medicine['name'],
                            quantity: medicine['quantity'],
                            container: medicine['container'],
                            user: widget.user),
                      ));
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
    );
  }
}
