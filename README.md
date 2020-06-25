# Sim plugin for Flutter

A Flutter plugin to retrieve Sim cards data - dual sim support - only Android for now.

## Installation

Add `sim_data` as a dependency in your pubspec.yaml.

Make sure that your `AndroidManifext.xml` file includes the following permission:
```xml
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
```

### Usage

Before you use this plugin, you must make sure that the user has authorized access to his phone, for example with the [permission_handler plugin](https://pub.dev/packages/permission_handler).

You may then use the plugin:
``` dart
import 'package:sim_data/sim_data.dart';

void printSimCardsData() async {
  try {
    SimData simData = await SimDataPlugin.getSimData();
    simData.cards.forEach((SimCard s) {
        print('Serial number: ${s.serialNumber}');
    });
  } catch(e) {
    debugPrint("error! code: ${e.code} - message: ${e.message}");
  }
}

void main() => printSimCardsData();
```
