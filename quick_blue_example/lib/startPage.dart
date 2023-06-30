import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'package:quick_blue/quick_blue.dart';
import 'package:http/http.dart' as http;

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
  bool isCollecting = false;
  bool option1 = false;
  bool option2 = false;
  bool option3 = false;
  String? measureName = null;
  int savedValue = 0;
  List<List<double>> receivedValues = [];
  List<Map<String, dynamic>> receivedJsonValues = [];
  //List<double> ImuValues = List<double>.filled(9, 0.0);

  @override
  void initState() {
    super.initState();
    // Initialize QuickBlue value handler to handle value changes for the characteristic
    QuickBlue.setValueHandler(_handleValueChange);
  }

  @override
  void dispose() {
    super.dispose();
    // Clear QuickBlue value handler
    QuickBlue.setValueHandler(null);
  }

//When a characteristic change he read the value and decode it
  void _handleValueChange(
      String deviceId, String characteristicId, Uint8List value) {
    List<double> floatValues = List<double>.filled(9, 0.0);
    if (characteristicId == "8e7c2dae-0002-4b0d-b516-f525649c49ca") {
      //IMU
      List<int> intValues = parseIMUData(value, 9);
      for (int i = 0; i < intValues.length; i++) {
        //conversion imu from int to float
        if (i < 3) {
          floatValues[i] = intValues[i] / 8192;
        } else if (i < 6) {
          floatValues[i] = intValues[i] / 16.384;
        } else {
          floatValues[i] = intValues[i] / 81.92;
        }
      }
      Map<String, dynamic> jsonObj = {
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "values": floatValues,
      };
      //To visualize jsonObj
      //String jsonString = jsonEncode(jsonObj);
      //print(jsonString);

      //print(floatValues);

      // Add the parsed IMU data to the receivedValues list
      setState(() {
        savedValue++;
        receivedJsonValues.add(jsonObj);
      });
    }
  }

  List<int> parseIMUData(Uint8List value, int ArrayLength) {
    final byteData = ByteData.view(value.buffer);
    final imuData = List<int>.filled(ArrayLength, 0);
    for (var i = 0; i < imuData.length; i++) {
      if (i < value.lengthInBytes ~/ 2) {
        int intValue = byteData.getInt16(i * 2, Endian.little);
        imuData[i] = intValue;
        print("intValue:" + intValue.toString());
      }
    }

    return imuData;
  }

  void toggleCollecting() {
    setState(() {
      isCollecting = !isCollecting;
    });
  }

  Future<void> sendData() async {
    print("ok send data to " + measureName.toString());
    String jsonString = jsonEncode(receivedJsonValues);
    print(jsonString);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'DVC eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkZXZpY2UiOnsiX2lkIjoidGVzdCIsImZlYXR1cmVzIjpbIklNVSJdLCJ0aGluZ3MiOlsidGVzdCJdLCJvd25lciI6IjY0NGI5Y2IxNTUxNDZhMDAxZTg2YmZkOCJ9LCJ0ZW5hbnQiOnsicGFzc3dvcmRoYXNoIjp0cnVlLCJfaWQiOiJhY3Rpdml0eS10cmFja2VyLXRlbmFudCIsIm9yZ2FuaXphdGlvbiI6Ik1lYXN1cmlmeSBvcmciLCJhZGRyZXNzIjoiTWVhc3VyaWZ5IFN0cmVldCwgR2Vub3ZhIiwiZW1haWwiOiJpbmZvQG1lYXN1cmlmeS5vcmciLCJwaG9uZSI6IiszOTEwMzIxODc5MzgxNyIsImRhdGFiYXNlIjoiYWN0aXZpdHktdHJhY2tlci10ZW5hbnQifSwiaWF0IjoxNjg4MDUxNDM1LCJleHAiOjMzMjQ1NjUxNDM1fQ.HCcoI8bscnthxx0Jxn6YQDydAJwA8k-eHFpceWEyD2I'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://students.measurify.org/v1/measurements/test/timeserie'));
    request.body = jsonString;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

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
                setState(() {
                  measureName = value;
                });
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
                toggleCollecting();
                // Handle button press
                if (option1) {
                  if (isCollecting) {
                    QuickBlue.setNotifiable(
                      widget.deviceId,
                      widget.serviceId,
                      "8e7c2dae-0002-4b0d-b516-f525649c49ca",
                      BleInputProperty.notification,
                    );
                  } else {
                    QuickBlue.setNotifiable(
                      widget.deviceId,
                      widget.serviceId,
                      "8e7c2dae-0002-4b0d-b516-f525649c49ca",
                      BleInputProperty.disabled,
                    );
                    sendData(); //TO DO to send data
                  }
                }
              },
              child: Text(!isCollecting ? 'Start' : 'Stop and Send'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Values saved: $savedValue'),
      ),
    );
  }
}
