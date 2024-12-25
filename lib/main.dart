import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
// import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SuspendedMonorail(),
    );
  }
}

class SuspendedMonorail extends StatefulWidget {
  @override
  SuspendedMonorailState createState() => SuspendedMonorailState();
}

class SuspendedMonorailState extends State<SuspendedMonorail> {
  // FlutterBlue flutterBlue = FlutterBlue.instance;
  // BluetoothDevice? _connectedDevice;
  // BluetoothCharacteristic? _characteristic;
  // int sentValue = 0;
  // int? receivedValue;

  @override
  void initState() {
    super.initState();
    // _startScan();
  }

  bool going = false, intermediate = false;
  String movementDirection = 'Forward';

  int _speedValue = 0;

  void _powerButton() {
    setState(() {
      intermediate = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        intermediate = false;
        going = !going;
      });
    });
  }

/*
  void _startScan() {
    flutterBlue.startScan(timeout: Duration(seconds: 5));
    flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (r.device.name == 'HC-05') {
          // Replace 'HC-05' with your Bluetooth module name
          _connectToDevice(r.device);
          flutterBlue.stopScan();
          break;
        }
      }
    });
  }

  void _connectToDevice(BluetoothDevice device) async {
    await device.connect();
    setState(() {
      _connectedDevice = device;
    });
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.write && characteristic.properties.read) {
          setState(() {
            _characteristic = characteristic;
          });
        }
      }
    }
  }


  void _sendInteger(int value) async {
    if (_characteristic != null) {
      List<int> bytes = utf8.encode(value.toString());
      await _characteristic!.write(bytes);
      setState(() {
        sentValue = value;
      });
    }
  }

  void _receiveInteger() async {
    if (_characteristic != null) {
      List<int> value = await _characteristic!.read();
      String receivedString = utf8.decode(value);
      setState(() {
        receivedValue = int.parse(receivedString.trim());
      });
    }
  }

  @override
  void dispose() {
    _connectedDevice?.disconnect();
    super.dispose();
  }
*/
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Suspended Railway Controller'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SfSlider(
                    min: 0.0,
                    max: 100.0,
                    value: _speedValue,
                    interval: 5,
                    stepSize: 5.0,
                    showTicks: true,
                    showLabels: true,
                    enableTooltip: true,
                    onChanged: (dynamic value) {
                      setState(() {
                        _speedValue = value;
                      });
                    },
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: intermediate
                      ? Colors.yellow
                      : going
                          ? Colors.green
                          : Colors.red,
                  onPressed: !intermediate ? _powerButton : null,
                  child: intermediate
                      ? Text(
                          going ? 'Stopping...' : 'Going...',
                          style: const TextStyle(color: Colors.grey),
                        )
                      : Text(
                          going ? 'Stop' : 'Go',
                          style: const TextStyle(color: Colors.white),
                        ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Text('Speed: $_speedValue'),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: DropdownButton<String>(
                      value: movementDirection,
                      isExpanded: true,
                      items: const ['Forward', 'Backward']
                          .map((directionValue) => DropdownMenuItem<String>(
                                value: directionValue,
                                child: Text(directionValue),
                              ))
                          .toList(),
                      onChanged: intermediate
                          ? null
                          : (String? directionValue) {
                              setState(() {
                                movementDirection = directionValue!;
                              });
                            },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
