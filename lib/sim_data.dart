import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import './sim_model.dart';

export './sim_model.dart';

class SimDataPlugin {
  static const String channel_name =
      "com.vincentkammerer.sim_data/channel_name";
  static const MethodChannel _channel = MethodChannel(channel_name);
  static Future<SimData> getSimData() async {
    try {
      dynamic simData = await _channel.invokeMethod('getSimData');
      var data = json.decode(simData);
      SimData simCards = SimData.fromJson(data);
      return simCards;
    } on PlatformException catch (e) {
      debugPrint('SimDataPlugin failed to retrieve data $e');
      throw e;
    }
  }
}
