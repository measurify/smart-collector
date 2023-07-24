import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'package:quick_blue/quick_blue.dart';
import 'package:http/http.dart' as http;
import 'configPage.dart';
import 'globals.dart';
import 'default.dart';

class startPage extends StatefulWidget {
  final Globals globals;
  startPage({required this.globals}); //required Global variables

  @override
  _startPageState createState() => _startPageState();
}

class _startPageState extends State<startPage> {
  //Create an object of type Defaults that contains default configuration values
  Defaults defaults = Defaults();

  List<String> sportsList = [];
  List<String> actionsList = [];

  String _selectedOption1 = "";
  String _selectedOption2 = "";

  //Input controller for Name of the measurement
  TextEditingController _measureNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load configuration variables from SharedPreferences
    loadConfigVariables();

    // Call the function to get tags
    fetchTags();

    // Initialize QuickBlue value handler to handle value changes for the characteristic
    QuickBlue.setValueHandler(_handleValueChange);
  }

  @override
  void dispose() {
    super.dispose();
    // Clear QuickBlue value handler
    QuickBlue.setValueHandler(null);
  }

  // Function to fetch activity tags
  void fetchTags() async {
    List<String> tags = await getActivityTags();
    setState(() {
      // Update the sportsList with the fetched tags
      sportsList = tags;
      _selectedOption1 = sportsList[0];
    });
    List<String> tags2 = await getActionTags();
    setState(() {
      // Update the sportsList with the fetched tags
      actionsList = tags2;
      _selectedOption2 = actionsList[0];
    });
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

    widget.globals.receivedIMUJsonValues =
        []; //TO DO save saved values not posted.
    //String? receivedIMUJsonValuesString =widget.globals.prefs.getString('receivedIMUJsonValues');
    //widget.globals.receivedIMUJsonValues = receivedIMUJsonValuesString != null
    // ? jsonDecode(receivedIMUJsonValuesString)
    // : [];

    //inizialize the input name as that saved from shared preferences
    _measureNameController.text = widget.globals.measureName;
  }

  //Save configuration variables to SharedPreferences (Not used for now)
  Future<void> saveConfigVariables() async {
    await widget.globals.prefs
        .setBool('isCollecting', widget.globals.isCollecting);
    await widget.globals.prefs.setBool('option1', widget.globals.option1);
    await widget.globals.prefs.setBool('option2', widget.globals.option2);
    await widget.globals.prefs.setBool('option3', widget.globals.option3);
    await widget.globals.prefs
        .setString('measureName', widget.globals.measureName);
    await widget.globals.prefs.setInt('savedValue', widget.globals.savedValue);
    await widget.globals.prefs.setString('receivedIMUJsonValues',
        jsonEncode(widget.globals.receivedIMUJsonValues));
  }

  //When a characteristic change he read the value and decode it and save into different variables
  void _handleValueChange(
      String deviceId, String characteristicId, Uint8List value) {
    if (characteristicId == "8e7c2dae-0002-4b0d-b516-f525649c49ca") {
      //IMU
      Map<String, dynamic> jsonObj = parseIMUData(value, 9);
      setState(() {
        // Add the parsed data to the receivedValues list of the specific characteristic
        widget.globals.receivedIMUJsonValues.add(jsonObj);
      });
    }
    //MISSING ENV AND ORIENTATION CHARACTERISTICS

    setState(() {
      widget.globals.savedValue++;
    });
  }

  //convert the IMU data 9 int16 array back to float and create the json object ready to be sended
  Map<String, dynamic> parseIMUData(Uint8List value, int ArrayLength) {
    final byteData = ByteData.view(value.buffer);
    final imuData = List<int>.filled(ArrayLength, 0);
    List<double> floatValues = List<double>.filled(9, 0.0);
    for (var i = 0; i < imuData.length; i++) {
      if (i < value.lengthInBytes ~/ 2) {
        int intValue = byteData.getInt16(i * 2, Endian.little);
        imuData[i] = intValue;
        print("intValue:" + intValue.toString());
      }
    }
    for (int i = 0; i < imuData.length; i++) {
      //conversion IMU from int to float
      if (i < 3) {
        floatValues[i] = imuData[i] / 8192;
      } else if (i < 6) {
        floatValues[i] = imuData[i] / 16.384;
      } else {
        floatValues[i] = imuData[i] / 81.92;
      }
    }
    Map<String, dynamic> jsonObj = {
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "values": floatValues,
    };
    //To visualize jsonObj
    //String jsonDataString = jsonEncode(jsonObj);
    //print(jsonDataString);
    //print(floatValues);
    return jsonObj;
  }

  //to start and stop collecting data, toggle isCollecting variable
  void toggleCollecting() {
    setState(() {
      widget.globals.isCollecting = !widget.globals.isCollecting;
    });
  }

  //send data to server using measureName (WORKS ONLY WITH IMU)
  //ERROR KNOWN If i create one measurement with that name I can't send more characteristic but only one, or I have to add _IMU at the end of the measure
  Future<void> sendData() async {
    print("Sending data to " + widget.globals.measureName.toString());
    String jsonDataString = jsonEncode(widget.globals.receivedIMUJsonValues);
    print(jsonDataString);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': widget.globals.deviceToken
    };
    var request = http.Request(
        'POST',
        Uri.parse(widget.globals.url +
            "measurements/" +
            widget.globals.measureName +
            '/timeserie'));
    request.body = jsonDataString;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      widget.globals.receivedIMUJsonValues = []; //reset
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Values sended correctly!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.reasonPhrase!)),
      );
      print(response.reasonPhrase);
    }
  }

  //Get all tags
  Future<List<String>> getActivityTags() async {
    List<String> activityTags = [];
    var headers = {'Authorization': widget.globals.deviceToken};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://students.measurify.org/v1/tags?filter={"tags": "Activity"}&sort={ "timestamp": "asc" }'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonResponse = await response.stream.bytesToString();
      Map<String, dynamic> tags = jsonDecode(jsonResponse);

      activityTags.addAll(
          tags["docs"].map((tag) => tag["_id"].toString()).cast<String>());
    } else {
      print(response.reasonPhrase);
    }
    return activityTags;
  }

  //Get all tags
  Future<List<String>> getActionTags() async {
    List<String> actionsTags = [];
    var headers = {'Authorization': widget.globals.deviceToken};
    var request = http.Request(
        'GET',
        Uri.parse('https://students.measurify.org/v1/tags?filter={"tags": "' +
            _selectedOption1 +
            '"}&sort={ "timestamp": "asc" }'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonResponse = await response.stream.bytesToString();
      // Assuming the response is a JSON array of tags like ["Tag1", "Tag2", ...]
      Map<String, dynamic> tags = jsonDecode(jsonResponse);
      // Convert each tag to a string and add it to the activityTags list
      actionsTags.addAll(
          tags["docs"].map((tag) => tag["_id"].toString()).cast<String>());
    } else {
      print(response.reasonPhrase);
    }
    return actionsTags;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Page'),
        actions: [
          // Add the gear icon button to access a new page
          IconButton(
            onPressed: () {
              // Navigate to the new page when the gear icon is pressed
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ConfigPage(globals: widget.globals)),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // First DropdownButton
            Text(
              'Choose Activity:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              value: _selectedOption1.isNotEmpty ? _selectedOption1 : "",
              onChanged: (String? newValue) async {
                setState(() {
                  _selectedOption1 = newValue!;
                });
                List<String> tags2 = await getActionTags();
                setState(() {
                  // Update the sportsList with the fetched tags
                  actionsList = tags2;
                  _selectedOption2 = actionsList[0];
                });
              },
              items: sportsList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            // Second DropdownButton
            Text(
              'Choose Action:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              value: _selectedOption2.isNotEmpty ? _selectedOption2 : "",
              onChanged: (String? newValue2) {
                setState(() {
                  _selectedOption2 = newValue2!;
                });
              },
              items: actionsList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16.0),
            Text(
              'Insert name of the measurement [Optional]:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              onChanged: (value) {
                // Handle text input changes
                setState(() {
                  widget.globals.measureName = value;
                });
              },
              controller: _measureNameController,
              decoration: InputDecoration(
                hintText: 'Enter some text',
              ),
              onSubmitted: (value) {
                widget.globals.prefs
                    .setString('measureName', widget.globals.measureName);
                print("saved measureName on sharedPreferences");
              },
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
                  value: widget.globals.option1,
                  onChanged: (value) {
                    setState(() {
                      widget.globals.option1 = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('ENVIRONMENT'),
                  value: widget.globals.option2,
                  onChanged: (value) {
                    setState(() {
                      widget.globals.option2 = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text('ORIENTATION'),
                  value: widget.globals.option3,
                  onChanged: (value) {
                    setState(() {
                      widget.globals.option3 = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (!widget.globals.option1 &&
                    !widget.globals.option2 &&
                    !widget.globals.option3) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Select at least on option!')),
                  );
                } else {
                  if (_selectedOption1 == "" || _selectedOption2 == "") {
                     ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Activity and Action can't be empty, please check that tags are in the database")),
                  );
                  } else {
                    toggleCollecting();
                    // Handle button press
                    if (widget.globals.option1) {
                      if (widget.globals.isCollecting) {
                        //create the measurement and start notification
                        await checkMeasureExist();
                        QuickBlue.setNotifiable(
                          widget.globals.deviceId,
                          widget.globals.bleServiceId,
                          widget.globals.imuCharacteristicId,
                          BleInputProperty.notification,
                        );
                      } else {
                        //stop notification and send data
                        QuickBlue.setNotifiable(
                          widget.globals.deviceId,
                          widget.globals.bleServiceId,
                          widget.globals.imuCharacteristicId,
                          BleInputProperty.disabled,
                        );
                        //send data (WORKS ONLY FOR IMU)
                        sendData();
                      }
                    }
                  }
                }
              },
              child: Text(
                  !widget.globals.isCollecting ? 'Start' : 'Stop and Send'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Values saved: ' + widget.globals.savedValue.toString()),
      ),
    );
  }

  //Check if exist a measure with that name //TO DO if exist check that the feature is the same of option selected
  Future<void> checkMeasureExist() async {
    if (widget.globals.measureName == '') {
      //postMeasure without id
      await postMeasure();
    } else {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': widget.globals.deviceToken
      };
      var request = http.Request(
          'GET',
          Uri.parse(widget.globals.url +
              "measurements/" +
              widget.globals.measureName));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
        //Create it //MAYBE MANAGE BETTER ERRORS.
        await postMeasure();
      }
    }
  }

  //Create measurement to save data
  Future<void> postMeasure() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': widget.globals.deviceToken
    };
    var request =
        http.Request('POST', Uri.parse(widget.globals.url + "measurements"));
    // Prepare the data to be sent in the request body as a Map
    Map<String, dynamic> requestBody = {
      "thing": widget.globals.thingName,
      "feature": "IMU",
      "device": widget.globals.deviceName,
      "tags": [_selectedOption1, _selectedOption2],
      "visibility": "public"
    };

    if (widget.globals.measureName != '' &&
        widget.globals.measureName.isNotEmpty) {
      // If the measureName is available, include it in the request body
      requestBody["_id"] = widget.globals.measureName;
    }

    // JSON encode the data in the request body
    String requestBodyJson = json.encode(requestBody);
    request.body = requestBodyJson;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String jsonResponse = await response.stream.bytesToString();
      print(jsonResponse);
      // Assuming the response is a JSON array of tags like ["Tag1", "Tag2", ...]
      Map<String, dynamic> measure = jsonDecode(jsonResponse);
      // Convert each tag to a string and add it to the activityTags list
      widget.globals.measureName = measure["_id"].toString();
    } else {
      print(request);
      print(response.toString());
      final snackBar = SnackBar(
        content: Text(response.reasonPhrase!),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
