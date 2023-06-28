import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'package:quick_blue/quick_blue.dart';

class startPage extends StatefulWidget {
  final String deviceId;
  final String serviceId;

  startPage({
    required this.deviceId,
    required this.serviceId,
  });

  @override
  _startPageState createState() => _startPageState();
}

class _startPageState extends State<startPage> {
  bool option1 = false;
  bool option2 = false;
  bool option3 = false;
  List<List<double>> receivedValues = [];
  List<double> ImuValues = List<double>.filled(9, 0.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                // Handle text input changes
              },
              decoration: InputDecoration(
                hintText: 'Enter some text',
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Select options:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              children: [
                CheckboxListTile(
                  title: Text('IMU'),
                  value: option1,
                  onChanged: (value) {
                    setState(() {
                      option1 = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('ENVIRONMENT'),
                  value: option2,
                  onChanged: (value) {
                    setState(() {
                      option2 = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('ORIENTATION'),
                  value: option3,
                  onChanged: (value) {
                    setState(() {
                      option3 = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Handle button press
                if (option1) {
                  List<String> charIds = [
                    "8e7c2dae-0005-4b0d-b516-f525649c49ca",
                    "8e7c2dae-0006-4b0d-b516-f525649c49ca",
                    "8e7c2dae-0007-4b0d-b516-f525649c49ca"
                  ];
                  // Start notifications for all selected characteristics
                  for (var charId in charIds) {
                    QuickBlue.setNotifiable(
                      widget.deviceId,
                      widget.serviceId,
                      charId,
                      BleInputProperty.notification,
                    );
                  }
                }
              },
              child: Text('Start'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Initialize QuickBlue value handler to handle value changes for the characteristic
    QuickBlue.setValueHandler(_handleValueChange);
    QuickBlue.setValueHandler(_handleValueChange);
    QuickBlue.setValueHandler(_handleValueChange);
  }

  @override
  void dispose() {
    super.dispose();
    // Clear QuickBlue value handler
    QuickBlue.setValueHandler(null);
  }

  void _handleValueChange(
      String deviceId, String characteristicId, Uint8List value) {
    print(characteristicId);
    final floatValues = parseIMUData(value);
    bool update = false;
    if (characteristicId == "8e7c2dae-0005-4b0d-b516-f525649c49ca") {
      ImuValues[0] = floatValues[0];
      ImuValues[1] = floatValues[1];
      ImuValues[2] = floatValues[2];
      print(ImuValues);
    }
    if (characteristicId == "8e7c2dae-0006-4b0d-b516-f525649c49ca") {
      ImuValues[3] = floatValues[0];
      ImuValues[4] = floatValues[1];
      ImuValues[5] = floatValues[2];
      print(ImuValues);
    }
    if (characteristicId == "8e7c2dae-0007-4b0d-b516-f525649c49ca") {
      ImuValues[6] = floatValues[0];
      ImuValues[7] = floatValues[1];
      ImuValues[8] = floatValues[2];
      print(ImuValues);
      update = true;
    }

    // Add the parsed IMU data to the receivedValues list
    if (update) {
      setState(() {
        receivedValues.add(floatValues);
      });
    }
  }

  List<double> parseIMUData(Uint8List value) {
    final byteData = ByteData.view(value.buffer);

    final imuData = List<double>.filled(3, 0.0);
    for (var i = 0; i < imuData.length; i++) {
      if (i < value.lengthInBytes ~/ 4) {
        double floatValue = byteData.getFloat32(i * 4, Endian.little);
        imuData[i] = floatValue;
      }
    }
    return imuData;
  }
}
