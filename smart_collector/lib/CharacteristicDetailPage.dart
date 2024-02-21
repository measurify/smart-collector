//NO MORE USED
/*
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:quick_blue/quick_blue.dart';

class CharacteristicDetailPage extends StatefulWidget {
  final String deviceId;
  final String serviceId;
  final String characteristicId;

  CharacteristicDetailPage({
    required this.deviceId,
    required this.serviceId,
    required this.characteristicId,
  });

  @override
  _CharacteristicDetailPageState createState() =>
      _CharacteristicDetailPageState();
}

class _CharacteristicDetailPageState extends State<CharacteristicDetailPage> {
  bool isNotifying = false;
  List<List<double>> receivedValues = [];
  List<double> ImuValues=List<double>.filled(9, 0.0);

  @override
  void initState() {
    super.initState();
    // Initialize QuickBlue value handler to handle value changes for the characteristic
    QuickBlue.setValueHandler(_handleValueChange);
  }
  void _handleValueChange(String deviceId, String characteristicId, Uint8List value) {
    final floatValues =parseIMUData(value);   
    bool update=false;
    if(characteristicId=="8e7c2dae-0005-4b0d-b516-f525649c49ca"){
      ImuValues[0]=floatValues[0];
      ImuValues[1]=floatValues[1];
      ImuValues[2]=floatValues[2];
    }
    if(characteristicId=="8e7c2dae-0006-4b0d-b516-f525649c49ca"){
      ImuValues[3]=floatValues[0];
      ImuValues[4]=floatValues[1];
      ImuValues[5]=floatValues[2];
    }
    if(characteristicId=="8e7c2dae-0007-4b0d-b516-f525649c49ca"){
      ImuValues[6]=floatValues[0];
      ImuValues[7]=floatValues[1];
      ImuValues[8]=floatValues[2];
      update=true;
      print(ImuValues);
    }
    
    // Add the parsed IMU data to the receivedValues list
    if(update){
    setState(() {
      receivedValues.add(floatValues);
    });}
}

  @override
  void dispose() {
    super.dispose();
    // Clear QuickBlue value handler
    QuickBlue.setValueHandler(null);
  }  

List<double> parseIMUData(Uint8List value) {
  final byteData = ByteData.view(value.buffer);

  final imuData = List<double>.filled(3, 0.0);
  for (var i = 0; i < imuData.length; i++) {
    if (i < value.lengthInBytes ~/ 4) {
      //int intValue = byteData.getInt32(i * 4, Endian.little);
      double floatValue = byteData.getFloat32(i * 4, Endian.little);
      imuData[i] = floatValue;
    }
  }
  return imuData;
}

String uint8ListToHex(Uint8List value) {
  return value.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
}

  void toggleNotifications() {
    if (isNotifying) {
      // Stop notifications
      QuickBlue.setNotifiable(
        widget.deviceId,
        widget.serviceId,
        widget.characteristicId,
        BleInputProperty.disabled,
      );
    } else {
      // Start notifications
      QuickBlue.setNotifiable(
        widget.deviceId,
        widget.serviceId,
        widget.characteristicId,
        BleInputProperty.notification,
      );
    }
    setState(() {
      isNotifying = !isNotifying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Characteristic Details'),
      ),
      body: Column(
        children: [
          Center(
            child: Text('Characteristic ID: ${widget.characteristicId}'),
          ),
          ElevatedButton(
            onPressed: toggleNotifications,
            child: Text(isNotifying ? 'Stop Notifications' : 'Start Notifications'),
          ),
          ElevatedButton(
            onPressed: () {
              //Navigator.push(
               // context,
               // MaterialPageRoute(builder: (context) => startPage( globals:widget.globals)),
              //);
            },
            child: Text('Go to Other Page'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: receivedValues.length,
              itemBuilder: (context, index) {
                final value = receivedValues[index];
                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Acceleration X: ${value[0]}'),
                      Text('Acceleration Y: ${value[1]}'),
                      Text('Acceleration Z: ${value[2]}')
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
*/