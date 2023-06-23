import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:quick_blue/quick_blue.dart';

class CharacteristicDetailPage extends StatefulWidget {
  final String deviceId;
  final String serviceId;
  final String characteristicId;

  CharacteristicDetailPage(
      {required this.deviceId,
        required this.serviceId,
        required this.characteristicId});

  @override
  _CharacteristicDetailPageState createState() =>
      _CharacteristicDetailPageState();
}

class _CharacteristicDetailPageState extends State<CharacteristicDetailPage> {
  bool isNotifying = false;
  List<Uint8List> receivedValues = [];

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

  void _handleValueChange(
      String deviceId, String characteristicId, Uint8List value) {

    // Add the received value to the list
    setState(() {

      receivedValues.add(value);
    });
  }

  // void _handleValueChange(
  //     String deviceId, String characteristicId, Uint8List value) {
  //   // Create a ByteData view of the Uint8List
  //   ByteData byteData = ByteData.view(value.buffer);
  //
  //   // Create a List to store the converted values
  //   List<int> convertedValues = [];
  //   // Iterate through each byte in the Uint8List
  //   for (int i = 0; i < value.length; i++) {
  //     // Get the signed integer value of the byte
  //     int intValue = byteData.getInt8(i);
  //
  //     convertedValues.add(intValue);
  //   }
  //
  //   // Add the converted values to the receivedValues list
  //   setState(() {
  //     receivedValues.addAll(convertedValues);
  //   });
  // }

  void toggleNotifications() {
    if (isNotifying) {
      // Stop notifications
      QuickBlue.setNotifiable(
          widget.deviceId, widget.serviceId, widget.characteristicId, BleInputProperty.disabled);
    } else {
      // Start notifications
      QuickBlue.setNotifiable(
          widget.deviceId, widget.serviceId, widget.characteristicId, BleInputProperty.notification);
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
          Expanded(
            child: ListView.builder(
              itemCount: receivedValues.length,
              itemBuilder: (context, index) {
                final value = receivedValues[index];
                return ListTile(
                  title: Text('Value: $value'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}