import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart';
import 'dart:convert';

class ConfigPage extends StatefulWidget {
  final Globals globals;
   ConfigPage({
    required this.globals
  });

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {

  TextEditingController _urlEditingController = TextEditingController();
  TextEditingController _tenantIdEditingController = TextEditingController();
  TextEditingController _deviceTokenEditingController = TextEditingController();
  TextEditingController _bleServiceIdEditingController = TextEditingController();
  TextEditingController _thingNameEditingController = TextEditingController();
  TextEditingController _deviceNameEditingController = TextEditingController();
  TextEditingController _imuCharacteristicIdEditingController = TextEditingController();
  TextEditingController _envCharacteristicIdEditingController = TextEditingController();
  TextEditingController _orientationCharacteristicIdEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  Future<void> loadPreferences() async {  
    _urlEditingController.text = widget.globals.url;
    _tenantIdEditingController.text = widget.globals.tenantId;
    _deviceTokenEditingController.text = widget.globals.deviceToken;
    _bleServiceIdEditingController.text = widget.globals.bleServiceId;
    _thingNameEditingController.text = widget.globals.thingName;
    _deviceNameEditingController.text = widget.globals.deviceName;
    _imuCharacteristicIdEditingController.text = widget.globals.imuCharacteristicId;
    _envCharacteristicIdEditingController.text = widget.globals.envCharacteristicId;
    _orientationCharacteristicIdEditingController.text = widget.globals.orientationCharacteristicId;
  }

  Future<void> saveSharedPreferences() async {
    await widget.globals.prefs.setString('url', widget.globals.url);
    await widget.globals.prefs.setString('tenantId', widget.globals.tenantId);
    await widget.globals.prefs.setString('deviceToken', widget.globals.deviceToken);
    await widget.globals.prefs.setString('bleServiceId', widget.globals.bleServiceId);
    await widget.globals.prefs.setString('thingName', widget.globals.thingName);
    await widget.globals.prefs.setString('deviceName', widget.globals.deviceName);
    await widget.globals.prefs.setString('imuCharacteristicId', widget.globals.imuCharacteristicId);
    await widget.globals.prefs.setString('envCharacteristicId', widget.globals.envCharacteristicId);
    await widget.globals.prefs.setString('orientationCharacteristicId', widget.globals.orientationCharacteristicId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Config Page'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('URL Measurify'),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        widget.globals.url = value;
                      });
                    },
                    controller: _urlEditingController,
                  ),
                  SizedBox(height: 16.0),
                  Text('ID Tenant'),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        widget.globals.tenantId = value;
                      });
                    },
                    controller: _tenantIdEditingController,
                  ),
                  SizedBox(height: 16.0),
                  Text('Token Device'),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        widget.globals.deviceToken = value;
                      });
                    },
                    controller: _deviceTokenEditingController,
                  ),
                  SizedBox(height: 16.0),
                  Text('ID servizio BLE'),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        widget.globals.bleServiceId = value;
                      });
                    },
                    controller: _bleServiceIdEditingController,
                  ),
                  SizedBox(height: 16.0),
                  Text('Thing Name'),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        widget.globals.thingName = value;
                      });
                    },
                    controller: _thingNameEditingController,
                  ),
                  SizedBox(height: 16.0),
                  Text('Device Name'),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        widget.globals.deviceName = value;
                      });
                    },
                    controller: _deviceNameEditingController,
                  ),
                  SizedBox(height: 16.0),
                  Text('IDs Characteristics'),
                  SizedBox(height: 8.0),
                  Text('IMU'),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        widget.globals.imuCharacteristicId = value;
                      });
                    },
                    controller: _imuCharacteristicIdEditingController,
                  ),
                  SizedBox(height: 8.0),
                  Text('ENV'),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        widget.globals.envCharacteristicId = value;
                      });
                    },
                    controller: _envCharacteristicIdEditingController,
                  ),
                  SizedBox(height: 8.0),
                  Text('ORIENTATION'),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        widget.globals.orientationCharacteristicId = value;
                      });
                    },
                    controller: _orientationCharacteristicIdEditingController,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      saveSharedPreferences();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Configurations saved')),
                      );
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 16.0,
            right: 16.0,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  resetConfigVariables();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Settings reset')),
                  );
                },
                child: Text('Reset Settings'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> resetConfigVariables() async {
    await widget.globals.prefs.setBool('isCollecting', defaults.isCollecting);
    await widget.globals.prefs.setBool('option1', defaults.option1);
    await widget.globals.prefs.setBool('option2', defaults.option2);
    await widget.globals.prefs.setBool('option3', defaults.option3);
    await widget.globals.prefs.setString('measureName', defaults.measureName);
    await widget.globals.prefs.setInt('savedValue', defaults.savedValue);
    await widget.globals.prefs.setString('url', defaults.url);
    await widget.globals.prefs.setString('tenantId', defaults.tenantId);
    await widget.globals.prefs.setString('deviceToken', defaults.deviceToken);
    await widget.globals.prefs.setString('bleServiceId', defaults.bleServiceId);
    await widget.globals.prefs.setString('thingName', defaults.thingName);
    await widget.globals.prefs.setString('deviceName', defaults.deviceName);
    await widget.globals.prefs.setString('imuCharacteristicId', defaults.imuCharacteristicId);
    await widget.globals.prefs.setString('envCharacteristicId', defaults.envCharacteristicId);
    await widget.globals.prefs.setString('orientationCharacteristicId', defaults.orientationCharacteristicId);

    String receivedIMUJsonValuesString = jsonEncode(defaults.receivedIMUJsonValues);
    await widget.globals.prefs.setString('receivedIMUJsonValues', receivedIMUJsonValuesString);
  }
}