class Defaults {
  String deviceId='';
  bool isCollecting = false;
  bool option1 = false;
  bool option2 = false;
  bool option3 = false;
  String measureName = '';
  int savedValue = 0;
  List<List<double>> receivedValues = [];
  List<Map<String, dynamic>> receivedIMUJsonValues = [];
  String url = 'https://students.measurify.org/v1/measurements/';
  String tenantId = 'activity-tracker-tenant';
  String deviceToken = 'DVC eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkZXZpY2UiOnsiX2lkIjoidGVzdCIsImZlYXR1cmVzIjpbIklNVSJdLCJ0aGluZ3MiOlsidGVzdCJdLCJvd25lciI6IjY0NGI5Y2IxNTUxNDZhMDAxZTg2YmZkOCJ9LCJ0ZW5hbnQiOnsicGFzc3dvcmRoYXNoIjp0cnVlLCJfaWQiOiJhY3Rpdml0eS10cmFja2VyLXRlbmFudCIsIm9yZ2FuaXphdGlvbiI6Ik1lYXN1cmlmeSBvcmciLCJhZGRyZXNzIjoiTWVhc3VyaWZ5IFN0cmVldCwgR2Vub3ZhIiwiZW1haWwiOiJpbmZvQG1lYXN1cmlmeS5vcmciLCJwaG9uZSI6IiszOTEwMzIxODc5MzgxNyIsImRhdGFiYXNlIjoiYWN0aXZpdHktdHJhY2tlci10ZW5hbnQifSwiaWF0IjoxNjg4MDUxNDM1LCJleHAiOjMzMjQ1NjUxNDM1fQ.HCcoI8bscnthxx0Jxn6YQDydAJwA8k-eHFpceWEyD2I';
  String thingName = 'test';
  String deviceName = 'test';
  String bleServiceId = '8e7c2dae-0000-4b0d-b516-f525649c49ca';
  String imuCharacteristicId = '8e7c2dae-0002-4b0d-b516-f525649c49ca';
  String envCharacteristicId = '8e7c2dae-0003-4b0d-b516-f525649c49ca';
  String orientationCharacteristicId = '8e7c2dae-0004-4b0d-b516-f525649c49ca';
}