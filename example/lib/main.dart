import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_data/sim_data.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  SimData? _simData;

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
          for (var s in simData.cards) {
            // ignore: avoid_print
            print('Serial number: ${s.serialNumber}');
          }
        } on PlatformException catch (e) {
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
    var cards = _simData?.cards;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Sim data demo')),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: cards != null
                    ? cards.isEmpty
                        ? [const Text('No sim card present')]
                        : cards
                            .map(
                              (SimCard card) => ListTile(
                                leading: const Icon(Icons.sim_card),
                                title: Text('Card ${card.slotIndex}'),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('carrierName: ${card.carrierName}'),
                                    Text('countryCode: ${card.countryCode}'),
                                    Text('displayName: ${card.displayName}'),
                                    Text(
                                        'isDataRoaming: ${card.isDataRoaming}'),
                                    Text(
                                        'isNetworkRoaming: ${card.isNetworkRoaming}'),
                                    Text('mcc: ${card.mcc}'),
                                    Text('mnc: ${card.mnc}'),
                                    Text('slotIndex: ${card.slotIndex}'),
                                    Text('serialNumber: ${card.serialNumber}'),
                                    Text(
                                        'subscriptionId: ${card.subscriptionId}'),
                                  ],
                                ),
                              ),
                            )
                            .toList()
                    : [
                        Center(
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Failed to load data'),
                        )
                      ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
