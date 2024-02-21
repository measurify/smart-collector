Smart Collector
=================
### Table of contents
- [Overview](https://github.com/Activity-Tracker-Framework/smart-collector#overview)
- [Getting Started](https://github.com/Activity-Tracker-Framework/smart-collector#getting-started)
- [Installation](https://github.com/Activity-Tracker-Framework/smart-collector#installation)    
    - [For Personal device](https://github.com/Activity-Tracker-Framework/smart-collector#for-personal-device)    
- [Usage](https://github.com/Activity-Tracker-Framework/smart-collector#Usage)
- [Citation](https://github.com/Activity-Tracker-Framework/smart-collector#Citation)
   
## Overview
# Smart Collector

Smart Collector is part of the Activity Tracker Framework, designed to efficiently collect and manage data from various sources for activity tracking purposes. It aims to provide a flexible and scalable solution for gathering, processing, and storing activity data, making it easier for developers to implement comprehensive activity tracking in their applications.

## Features

- **Data Collection**: Collects data from edge-meter [LINK](https://github.com/Activity-Tracker-Framework/edge-meter) and collect them as timeseries.
- **End-to-End**: Transmits data from the edge device to the cloud of Measurify [LINK](https://github.com/measurify/server).
- **Security**: Implements best practices to ensure data is collected, processed, and stored securely.
- **Multi-Platform Support:** Collect data from multiple sources with ease.
- **Real-Time Processing:** Process data in real-time to gain immediate insights.

## Getting Started

### Prerequisites

- Visual Studio Code installed
- Flutter installed correctly (check with "flutter doctor -v")
- Measurify Cloud server [LINK](https://github.com/measurify/server)
- Arduino Nano 33 BLE / Arduino Nano 33 BLE Sense 
- Edge-Meter firmware [LINK](https://github.com/Activity-Tracker-Framework/edge-meter)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Activity-Tracker-Framework/smart-collector.git

2. Open in VS Code the directory smart_collector:

3. Run flutter pub get
```
flutter pub get
```

4. set the parameters in default.dart

5. Run the code

    #### For Personal device

    Activate Developer Options. Firstly, launch the app and click the "Request Permissions" button at the bottom of the initial page. Tap on this button to grant the app permissions for using Bluetooth Low Energy (BLE) and to discover devices.    

## Usage

### Application
The application consists of a first page where you choose the device of interest Edge-Meter. Followed by a page to connect to the device and continue. The StartPage allows you to select the activity performed and the actions to be collected and start and stop sampling. 

### Code
The code can be found inside smart_collector/lib/ and consists of:

- default.dart: All important application settings for communication
- globals.dart: All settings declaration
- main.dart: First page with the selection of the device
- PeripheralDetailPage.dart: Page to connect to the device
- CharacteristicDetailPage.dart: NO MORE USED Command for BLE communication
- startPage.dart: Page to set labels for activity, actions, measurement name, and select IMU, ORI, ENV data and start/stop recording
- configPage.dart: To change settings from the app. Changes should need a restart of the app.

# Citation
If you find the project helpful, please consider citing our paper:

[1] M. Fresta, A. Dabbous, F. Bellotti, A. Capello, L. Lazzaroni, A. Pighetti, R. Berta.
 **Low-Cost, Edge-Cloud, End-to-End System Architecture for Human Activity Data Collection**. Applications in Electronics Pervading Industry, Environment and Society. ApplePies 2023. Lecture Notes in Electrical Engineering, vol 1110. Springer, Cham. [LINK](https://doi.org/10.1007/978-3-031-48121-5_64)

[2] A. Dabbous, M. Fresta, F. Bellotti, R. Berta. **Neural Architecture for Tennis Shot Classification on Embedded System**. Applications in Electronics Pervading Industry, Environment and Society. ApplePies 2023. Lecture Notes in Electrical Engineering, vol 1110. Springer, Cham. [LINK](https://doi.org/10.1007/978-3-031-48121-5_14)

[3] A. Dabbous, M. Fresta, F. Bellotti, R. Berta. **Arduino Nano-based System for Tennis Shot Classification**. 54th Annual Meeting of the Italian Electronics Society, SIE 2023, Noto, Italy, 2023. [LINK](https://doi.org/10.1007/978-3-031-48711-8_43)

