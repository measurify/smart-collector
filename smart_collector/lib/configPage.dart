import 'package:flutter/material.dart';
import 'globals.dart';

class ConfigPage extends StatefulWidget {
  final Globals globals;
   ConfigPage({
    required this.globals //required
  });

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  //input controllers
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
    initializeTextControllers();
  }

  //initialize Text controllers
  Future<void> initializeTextControllers() async {  
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

  //for save button update the shared preferences
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

  //reset all the values to default. [CHECK FOR MISSING]
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

    
    //String receivedIMUJsonValuesString = jsonEncode(defaults.receivedIMUJsonValues);
    //await widget.globals.prefs.setString('receivedIMUJsonValues', receivedIMUJsonValuesString);

    //update the globals variables
    loadConfigVariables();
    
  }

  // Retrieve configuration variables from SharedPreferences
  Future<void> loadConfigVariables() async {
    widget.globals.isCollecting =
        widget.globals.prefs.getBool('isCollecting') ?? defaults.isCollecting;
    widget.globals.option1 =
        widget.globals.prefs.getBool('option1') ?? defaults.option1;
    widget.globals.option2 =
        widget.globals.prefs.getBool('option2') ?? defaults.option2;
    widget.globals.option3 =
        widget.globals.prefs.getBool('option3') ?? defaults.option3;
    widget.globals.measureName =
        widget.globals.prefs.getString('measureName') ?? defaults.measureName;
    widget.globals.savedValue =
        widget.globals.prefs.getInt('savedValue') ?? defaults.savedValue;
    widget.globals.url = widget.globals.prefs.getString('url') ?? defaults.url;
    widget.globals.tenantId =
        widget.globals.prefs.getString('tenantId') ?? defaults.tenantId;
    widget.globals.deviceToken =
        widget.globals.prefs.getString('deviceToken') ?? defaults.deviceToken;
    widget.globals.bleServiceId =
        widget.globals.prefs.getString('bleServiceId') ?? defaults.bleServiceId;
    widget.globals.thingName =
        widget.globals.prefs.getString('thingName') ?? defaults.thingName;
    widget.globals.deviceName =
        widget.globals.prefs.getString('deviceName') ?? defaults.deviceName;
    widget.globals.imuCharacteristicId =
        widget.globals.prefs.getString('imuCharacteristicId') ??
            defaults.imuCharacteristicId;
    widget.globals.envCharacteristicId =
        widget.globals.prefs.getString('envCharacteristicId') ??
            defaults.envCharacteristicId;
    widget.globals.orientationCharacteristicId =
        widget.globals.prefs.getString('orientationCharacteristicId') ??
            defaults.orientationCharacteristicId;

    
    widget.globals.receivedIMUJsonValues=[];//TO DO save saved values not posted.
    //String? receivedIMUJsonValuesString =widget.globals.prefs.getString('receivedIMUJsonValues');
    //widget.globals.receivedIMUJsonValues = receivedIMUJsonValuesString != null
       // ? jsonDecode(receivedIMUJsonValuesString)
       // : [];
    

  }
}