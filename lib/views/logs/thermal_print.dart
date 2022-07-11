import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:patient/theme/theme.dart';
import 'package:patient/widgets/custom_button.dart';

class ThermalPrint extends StatefulWidget {
  final String id;
  final String medicationId;
  final String patientID;
  final String patientName;
  final String medicineId;
  final String medicineName;
  final String schedule;
  final String status;
  const ThermalPrint(
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
  _ThermalPrintState createState() => _ThermalPrintState();
}

class _ThermalPrintState extends State<ThermalPrint> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _connected = false;
  bool _pressed = false;
  String? pathImage;

  final format = NumberFormat("\$###,###.00", "en_US");

  @override
  void initState() {
    super.initState();
   
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      initPlatformState();
    });
  }

  Future<void> initPlatformState() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            _pressed = false;
            _devices = devices;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            _pressed = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: _connected ? null : () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: _connected ? Colors.grey : Colors.white,),),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Device:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton(
                        items: _getDeviceItems(),
                        onTap: () => setState(() {
                          _getDeviceItems();
                        }),
                        onChanged: (BluetoothDevice? value) =>
                            setState(() => _device = value),
                        value: _device,
                      ),
                    ],
                  ),
                  const SizedBox(height: CustomSpacing.medium),
                  CustomButton.small(
                    text: _connected ? 'Disconnect' : 'Connect',
                    onPressed: _pressed
                        ? null
                        : _connected
                            ? _disconnect
                            : _connect,
                  ),
                ],
              ),
            ),
            SizedBox(height: CustomSpacing.medium),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              child: CustomButton.small(
                icon: Icon(Icons.print),
                text: 'Print  ',
                onPressed: _connected ? _startPrint : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(const DropdownMenuItem(
        alignment: Alignment.center,
        child: Center(
          child: Text(' None'),
        ),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          alignment: Alignment.center,
          child: Center(
            child: Text(device.name!),
          ),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device == null) {
      show('No device selected');
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected!) {
          bluetooth.connect(_device!).catchError((error) {
            setState(() => _pressed = false);
          });
          setState(() => _pressed = true);
        }
      });
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _pressed = true);
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  void _startPrint() async {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected!) {
        bluetooth.printNewLine();
        bluetooth.printCustom("MDC Management System", 3, 1);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printCustom("Bacolod City,", 2, 1);
        bluetooth.printCustom("Philippines", 2, 1);

        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printCustom("ID: ", 1, 0);
        bluetooth.printCustom("${widget.id} ",1, 0);
        bluetooth.printNewLine();
        bluetooth.printCustom("Medication ID: ", 1, 0);
        bluetooth.printCustom("${widget.medicationId} ", 1, 0);
        bluetooth.printNewLine();
        bluetooth.printCustom("Patient ID: ", 1, 0);
        bluetooth.printCustom("${widget.patientID} ", 1, 0);
        bluetooth.printNewLine();
        bluetooth.printCustom("Patient Name: ", 1, 0);
        bluetooth.printCustom("${widget.patientName} ", 1, 0);
        bluetooth.printNewLine();
        bluetooth.printCustom("Medicine ID: ", 1, 0);
        bluetooth.printCustom("${widget.medicineId} ", 1, 0);
        bluetooth.printNewLine();
        bluetooth.printCustom("Medicine Name: ", 1, 0);
        bluetooth.printCustom("${widget.medicineName} ", 1, 0);
        bluetooth.printNewLine();
        bluetooth.printCustom("Schedule: ", 1, 0);
        bluetooth.printCustom("${widget.schedule} ", 1, 0);
        bluetooth.printNewLine();
        bluetooth.printCustom("Status: ", 1, 0);
        bluetooth.printCustom("${widget.status} ", 1, 0);



        //Mapped items here
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printCustom("Thank You!", 2, 1);
        bluetooth.printNewLine();
        bluetooth.printQRcode("Invoice# 12345", 200, 200, 1);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.paperCut();
      }
    });
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

     SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      duration: duration,
    );
  }
}
