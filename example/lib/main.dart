import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_data/sim_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  SimData _simData;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    SimData simData;
    try {
      var status = await Permission.phone.status;
      if (!status.isGranted) {
        bool isGranted = await Permission.phone.request().isGranted;
        if (!isGranted) return;
      }
      simData = await SimDataPlugin.getSimData();
      setState(() {
        _isLoading = false;
        _simData = simData;
      });
      void printSimCardsData() async {
        try {
          SimData simData = await SimDataPlugin.getSimData();
          simData.cards.forEach((SimCard s) {
            print('Serial number: ${s.serialNumber}');
          });
        } catch (e) {
          debugPrint("error! code: ${e.code} - message: ${e.message}");
        }
      }

      printSimCardsData();
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        _isLoading = false;
        _simData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Sim data demo'),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                  children: _simData != null &&
                          _simData.cards is List &&
                          _simData.cards.length > 0
                      ? _simData.cards.map((SimCard card) {
                          return ListTile(
                            leading: Icon(Icons.sim_card),
                            title: Text('Card ${card.slotIndex}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('carrierName: ${card.carrierName}'),
                                Text('countryCode: ${card.countryCode}'),
                                Text('displayName: ${card.displayName}'),
                                Text('isDataRoaming: ${card.isDataRoaming}'),
                                Text(
                                    'isNetworkRoaming: ${card.isNetworkRoaming}'),
                                Text('mcc: ${card.mcc}'),
                                Text('mnc: ${card.mnc}'),
                                Text('slotIndex: ${card.slotIndex}'),
                                Text('serialNumber: ${card.serialNumber}'),
                                Text('subscriptionId: ${card.subscriptionId}'),
                              ],
                            ),
                          );
//
//                          return Container(
//                            child: Center(
//                              child: Column(
//                                children: <Widget>[
//                                  Text(card.carrierName),
//                                  Text(card.displayName),
//                                  Text(card.countryCode),
//                                  Text('data roaming is ${card.isDataRoaming}')
//                                ],
//                              ),
//                            ),
//                          );
                        }).toList()
                      : [
                          Center(
                            child: _isLoading
                                ? CircularProgressIndicator()
                                : Text('Failed to load data'),
                          )
                        ]),
            )
          ],
        ),
      ),
    );
  }
}
