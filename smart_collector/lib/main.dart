import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:quick_blue/quick_blue.dart';

import 'PeripheralDetailPage.dart';
import 'package:permission_handler/permission_handler.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<BlueScanResult>? _subscription;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      QuickBlue.setLogger(Logger('smart_collector'));
    }
    //search for devices and choice only the device with a name
    _subscription = QuickBlue.scanResultStream.listen((result) {
      if (!_scanResults.any((r) => r.deviceId == result.deviceId)) {
        if(result.name!=""){setState(() => _scanResults.add(result));}
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            FutureBuilder(
              future: QuickBlue.isBluetoothAvailable(),
              builder: (context, snapshot) {
                var available = snapshot.data?.toString() ?? '...';
                return Text('Bluetooth init: $available');
              },
            ),
            _buildButtons(),
            Divider(
              color: Colors.blue,
            ),
            _buildListView(),
            _buildPermissionWarning(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton(
          child: Text('startScan'),
          onPressed: () {
            QuickBlue.startScan();
          },
        ),
        ElevatedButton(
          child: Text('stopScan'),
          onPressed: () {
            QuickBlue.stopScan();
          },
        ),
      ],
    );
  }

  var _scanResults = <BlueScanResult>[];

  Widget _buildListView() {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (context, index) => ListTile(
          title:
              Text('${_scanResults[index].name}(${_scanResults[index].rssi})'),
          subtitle: Text(_scanResults[index].deviceId),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PeripheralDetailPage(_scanResults[index].deviceId),
                ));
          },
        ),
        separatorBuilder: (context, index) => Divider(),
        itemCount: _scanResults.length,
      ),
    );
  }
  //button to set permission
  Widget _buildPermissionWarning() {
    return FutureBuilder<bool>(
      future: _hasBluetoothPermission(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          bool hasNoPermission = !(snapshot.data!);
          if (hasNoPermission) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  // Text('BLUETOOTH_SCAN/ACCESS_FINE_LOCATION needed'),
                  ElevatedButton(
                    child: Text('Request Permissions'),
                    onPressed: () {
                      _requestBluetoothPermissions();
                    },
                  ),
                ],
              ),
            );
          }
        }
        return Container();
      },
    );
  }

  void _requestBluetoothPermissions() async {
    if (Platform.isAndroid) {
      List<Permission> permissions = [
        Permission.bluetooth,
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
        Permission.location,
      ];

      Map<Permission, PermissionStatus> permissionStatuses =
      await permissions.request();

      setState(() {
        // Check if permissions were granted
        bool permissionsGranted = permissionStatuses.values
            .every((status) => status == PermissionStatus.granted);

        if (permissionsGranted) {
          // Permissions were granted, perform necessary actions
          // For example, start scanning for Bluetooth devices
          QuickBlue.startScan();
        } else {
          // Permissions were not granted, handle accordingly
          // For example, show an error message
          print('Permissions not granted.');
        }
      });
    }
  }

  Future<bool> _hasBluetoothPermission() async {
    bool isAndroid = Platform.isAndroid;
    bool bluetoothPermission = await hasPermission(Permission.bluetooth);
    bool bluetoothConnectPermission = await hasPermission(Permission.bluetoothConnect);
    bool bluetoothScanPermission = await hasPermission(Permission.bluetoothScan);
    bool locationPermission = await hasPermission(Permission.location);

    return isAndroid && bluetoothPermission && bluetoothConnectPermission && bluetoothScanPermission && locationPermission;
  }

  Future<bool> hasPermission(Permission permission) async {
    PermissionStatus status = await permission.status;
    return status.isGranted;
  }
}
