import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'dart:typed_data';

import 'package:quick_blue/quick_blue.dart';
import 'package:http/http.dart' as http;
import 'configPage.dart';
import 'globals.dart';
import 'default.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class chartCartesianPage extends StatefulWidget {
  final Globals globals;
  chartCartesianPage({required this.globals}); //required Global variables

  @override
  _chartCartesianPageState createState() => _chartCartesianPageState();
}

class ChartDataIMU {
  final String timestamp;
  final double accX;
  final double accY;
  final double accZ;
  final double gyrX;
  final double gyrY;
  final double gyrZ;
  final double magX;
  final double magY;
  final double magZ;

  ChartDataIMU(this.timestamp, this.accX, this.accY, this.accZ, this.gyrX,
      this.gyrY, this.gyrZ, this.magX, this.magY, this.magZ);
}

class _chartCartesianPageState extends State<chartCartesianPage> {
  //Create an object of type Defaults that contains default configuration values
  Defaults defaults = Defaults();

  List<String> allMeasurements = [];
  List<String> selectTimeseries = [];

  String _selectedOption = "";

  late TooltipBehavior _tooltipBehavior;
  late List<CartesianSeries<dynamic, dynamic>> series;
  late List<ChartDataIMU> chartDataIMUList = [];
  late Map<String, dynamic> tags4;
  bool isMarkerVisible = true;
  bool isTooltipVisible = true;
  double? lineWidth, markerWidth, markerHeight;

  //Input controller for Name of the measurement
  TextEditingController _measureNameController = TextEditingController();

  get floatValues => null;

  @override
  void initState() {
    super.initState();
    // Load configuration variables from SharedPreferences
    loadConfigVariables();
    chartDataIMUList = [];

    /*chartDataIMUList.add(ChartDataIMU(DateTime.now(), 10,50));
    chartDataIMUList.add(ChartDataIMU(DateTime.now().add(Duration(milliseconds: 150)), 20,40));
    chartDataIMUList.add(ChartDataIMU(DateTime.now().add(Duration(milliseconds: 300)), 30,30));
    chartDataIMUList.add(ChartDataIMU(DateTime.now().add(Duration(milliseconds: 450)), 40,20));
    chartDataIMUList.add(ChartDataIMU(DateTime.now().add(Duration(milliseconds: 600)), 50,10));*/

    // Call the function to get Measurements
    fetchMeasurements();

    /* Initialize QuickBlue value handler to handle value changes for the characteristic
    QuickBlue.setValueHandler(_handleValueChange);*/
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  @override
  void dispose() {
    super.dispose();
    // Clear QuickBlue value handler
    //QuickBlue.setValueHandler(null);
  }

  // Function to fetch activity Measurements
  void fetchMeasurements() async {
    List<String> measurements = await getAllMeasurements();
    print(measurements);
    setState(() {
      // Update the measurements list with the fetched Measurements
      allMeasurements = measurements;
      _selectedOption = allMeasurements[0];
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

    widget.globals.receivedIMUJsonValues = [];
    _measureNameController.text = widget.globals.measureName;
  }

//get All Description Measurements
  Future<List<String>> getAllMeasurements() async {
    List<String> allMeasurements = [];
    var headers = {'Authorization': widget.globals.deviceToken};
    var request = http.Request('GET',
        Uri.parse(widget.globals.url + 'measurements?select["_id"]&limit=-1'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonResponse = await response.stream.bytesToString();
      Map<String, dynamic> measurements = jsonDecode(jsonResponse);

      allMeasurements.addAll(measurements["docs"]
          .map((measure) => measure["_id"].toString())
          .cast<String>());
    } else {
      print(response.reasonPhrase);
    }
    return allMeasurements;
  }

//get select Timeseries
  Future<List<dynamic>> getSelectTimeseries() async {
    Map<dynamic, dynamic> timeSeries = {
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "values": floatValues,
    };
    List<dynamic> TimeSeriesList = [];
    var headers = {'Authorization': widget.globals.deviceToken};
    var request = http.Request(
        'GET',
        Uri.parse(widget.globals.url +
            'measurements/' +
            _selectedOption +
            '/timeserie?limit=300&sort={"timestamp":"asc"}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String jsonResponse = await response.stream.bytesToString();
      Map<dynamic, dynamic> timeseries = jsonDecode(jsonResponse);

      TimeSeriesList.addAll(timeseries["docs"].map((timeserie) {
        return {
          "timestamp": timeserie["timestamp"],
          "accX": timeserie["values"][0].toDouble(),
          "accY": timeserie["values"][1].toDouble(),
          "accZ": timeserie["values"][2].toDouble(),
          "gyrX": timeserie["values"][3].toDouble(),
          "gyrY": timeserie["values"][4].toDouble(),
          "gyrZ": timeserie["values"][5].toDouble(),
          "magX": timeserie["values"][6].toDouble(),
          "magY": timeserie["values"][7].toDouble(),
          "magZ": timeserie["values"][8].toDouble(),
        };
      }).toList());
    } else {
      print(response.reasonPhrase);
    }
    return TimeSeriesList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chart Page'),
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
              'Choose Measurement:',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              value: _selectedOption.isNotEmpty ? _selectedOption : "",
              onChanged: (String? newValue) async {
                setState(() {
                  _selectedOption = newValue!;
                });
                List<dynamic> measurements = await getSelectTimeseries();
                setState(() {
                  chartDataIMUList = [];
                  chartDataIMUList.addAll(measurements.map((measure) {
                    return ChartDataIMU(
                        measure["timestamp"],
                        measure["accX"],
                        measure["accY"],
                        measure["accZ"],
                        measure["gyrX"],
                        measure["gyrY"],
                        measure["gyrZ"],
                        measure["magX"],
                        measure["magY"],
                        measure["magZ"]);
                  }));
                });
              },
              items:
                  allMeasurements.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            // Use Expanded widget to make the chart take up all available remaining space
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    // Wrap the chart call with Expanded
                    child: _buildDefaultLineChart(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
      ),
    );
  }

  /// Get the cartesian chart with default line series
  SfCartesianChart _buildDefaultLineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'Time Series'),
      legend:
          Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
      primaryXAxis: CategoryAxis(interval: 2, labelRotation: 80),
      /*const NumericAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          interval: 2,
          majorGridLines: MajorGridLines(width: 0)),*/
      primaryYAxis: NumericAxis(
          labelFormat: '{value}',
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(color: Colors.transparent)),
      series: _getDefaultLineSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// The method returns line series to chart.
  List<LineSeries<dynamic, dynamic>> _getDefaultLineSeries() {
    return <LineSeries<dynamic, dynamic>>[
      LineSeries<ChartDataIMU, String>(
        dataSource: chartDataIMUList,
        xValueMapper: (ChartDataIMU sales, _) => sales.timestamp,
        yValueMapper: (ChartDataIMU sales, _) => sales.accX,
        name: 'accX',
        /*markerSettings: const MarkerSettings(isVisible: true)*/
      ),
      LineSeries<ChartDataIMU, String>(
        dataSource: chartDataIMUList,
        name: 'accY',
        xValueMapper: (ChartDataIMU sales, _) => sales.timestamp,
        yValueMapper: (ChartDataIMU sales, _) => sales.accY,
        /*markerSettings: const MarkerSettings(isVisible: true)*/
      ),
      LineSeries<ChartDataIMU, String>(
        dataSource: chartDataIMUList,
        xValueMapper: (ChartDataIMU sales, _) => sales.timestamp,
        yValueMapper: (ChartDataIMU sales, _) => sales.accZ,
        name: 'accZ',
        /*markerSettings: const MarkerSettings(isVisible: true)*/
      ),
      LineSeries<ChartDataIMU, String>(
        dataSource: chartDataIMUList,
        xValueMapper: (ChartDataIMU sales, _) => sales.timestamp,
        yValueMapper: (ChartDataIMU sales, _) => sales.gyrX,
        name: 'gyrX',
        /*markerSettings: const MarkerSettings(isVisible: true)*/
      ),
      LineSeries<ChartDataIMU, String>(
        dataSource: chartDataIMUList,
        xValueMapper: (ChartDataIMU sales, _) => sales.timestamp,
        yValueMapper: (ChartDataIMU sales, _) => sales.gyrY,
        name: 'gyrY',
        /*markerSettings: const MarkerSettings(isVisible: true)*/
      ),
      LineSeries<ChartDataIMU, String>(
        dataSource: chartDataIMUList,
        xValueMapper: (ChartDataIMU sales, _) => sales.timestamp,
        yValueMapper: (ChartDataIMU sales, _) => sales.gyrZ,
        name: 'gyrZ',
        /*markerSettings: const MarkerSettings(isVisible: true)*/
      ),
      LineSeries<ChartDataIMU, String>(
        dataSource: chartDataIMUList,
        xValueMapper: (ChartDataIMU sales, _) => sales.timestamp,
        yValueMapper: (ChartDataIMU sales, _) => sales.magX,
        name: 'magX',
        /*markerSettings: const MarkerSettings(isVisible: true)*/
      ),
      LineSeries<ChartDataIMU, String>(
        dataSource: chartDataIMUList,
        xValueMapper: (ChartDataIMU sales, _) => sales.timestamp,
        yValueMapper: (ChartDataIMU sales, _) => sales.magY,
        name: 'magY',
        /*markerSettings: const MarkerSettings(isVisible: true)*/
      ),
      LineSeries<ChartDataIMU, String>(
        dataSource: chartDataIMUList,
        xValueMapper: (ChartDataIMU sales, _) => sales.timestamp,
        yValueMapper: (ChartDataIMU sales, _) => sales.magZ,
        name: 'magZ', /*markerSettings: const MarkerSettings(isVisible: true)*/
      )
    ];
  }
}
