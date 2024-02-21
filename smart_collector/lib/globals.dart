import 'package:shared_preferences/shared_preferences.dart';
import 'default.dart';
Defaults defaults = Defaults();

class Globals {
  String deviceId='';
  bool isCollecting = defaults.isCollecting;
  bool option1 = false;
  bool option2 = false;
  bool option3 = false ;
  String measureName = '';
  int savedValue = 0;
  List<List<double>> receivedValues = [];
  List<Map<String, dynamic>> receivedIMUJsonValues = [];
  String url = '';
  String tenantId = '';
  String deviceToken = '';
  String thingName = '';
  String deviceName = '';
  String bleServiceId = '';
  String imuCharacteristicId = '';
  String envCharacteristicId = '';
  String orientationCharacteristicId = '';
  late SharedPreferences prefs; // SharedPreferences instance
}