import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:http/http.dart' as http;

class MLModel extends StatefulWidget {
  @override
  _MLModelState createState() => _MLModelState();
}

class _MLModelState extends State<MLModel> {
  dynamic output = 'nothing';

  Queue<bool> q = Queue<bool>();

  int count = 0;

  int countAcc = 0, countGyro = 0;
  List<double> gyroValue = <double>[0, 0, 0];
  List<double> accValue = <double>[0, 0, 0];

  Duration duration = Duration(seconds: 1, milliseconds: 0);
  @override
  Widget build(BuildContext context) {
    q.add(true);
    Timer.periodic(duration, (Timer t) async {
      // print('$accValue $countAcc');
      // if (!q.contains(true)) {}
      List<double> meanAcc = <double>[
        double.parse((accValue[0] / countAcc).toStringAsFixed(3)),
        double.parse((accValue[1] / countAcc).toStringAsFixed(3)),
        double.parse((accValue[2] / countAcc).toStringAsFixed(3))
      ];

      List<double> meanGyro = <double>[
        double.parse((gyroValue[0] / countGyro).toStringAsFixed(3)),
        double.parse((gyroValue[1] / countGyro).toStringAsFixed(3)),
        double.parse((gyroValue[2] / countGyro).toStringAsFixed(3))
      ];

      print('Accelerometer: ${accValue[0]} ${accValue[1]} ${accValue[2]}');
      print('Gyroscope: ${gyroValue[0]} ${gyroValue[1]} ${gyroValue[2]}');

      for (int i = 0; i < 3; i++) {
        accValue[i] = 0;
        gyroValue[i] = 0;
      }
      countAcc = 0;
      countGyro = 0;

      print(
          'https://serene-ocean-45579.herokuapp.com/?a=${76}&b=${meanAcc[0]}&c=${meanAcc[1]}&d=${meanAcc[2]}&r=${meanGyro[0]}5&g=${meanGyro[1]}&t=${meanGyro[2]}');

      int x = Random().nextInt(100);
      print('######################################Sending Request $count');
      http.Response res = await http.get(
          'https://serene-ocean-45579.herokuapp.com/?a=${76}&b=${meanAcc[0]}&c=${meanAcc[1]}&d=${meanAcc[2]}&r=${meanGyro[0]}5&g=${meanGyro[1]}&t=${meanGyro[2]}');
      print('######################################Got Response  $count');
      count += 1;
      print(res.body);
      setState(() {
        output = res.body;
      });
    });

    accelerometerEvents.listen((AccelerometerEvent event) {
      countAcc += 1;
      accValue[0] += event.x is double
          ? double.parse(event.x.toStringAsFixed(3)) / 160
          : 0.0;
      accValue[1] += event.y is double
          ? double.parse(event.y.toStringAsFixed(3)) / 160
          : 0.0;
      accValue[2] += event.z is double
          ? double.parse(event.z.toStringAsFixed(3)) / 160
          : 0.0;

      // print('Accelerometer: ${accValue[0]} ${accValue[1]} ${accValue[2]}');
    });
// [UserAccelerometerEvent (x: 0.0, y: 0.0, z: 0.0)]

    gyroscopeEvents.listen((GyroscopeEvent event) {
      countGyro += 1;
      gyroValue[0] +=
          event.x is double ? double.parse(event.x.toStringAsFixed(3)) : 0.0;
      gyroValue[1] +=
          event.y is double ? double.parse(event.y.toStringAsFixed(3)) : 0.0;
      gyroValue[2] +=
          event.z is double ? double.parse(event.z.toStringAsFixed(3)) : 0.0;
      // print('Gyroscope: ${gyroValue[0]} ${gyroValue[1]} ${gyroValue[2]}');
    });

// [GyroscopeEvent (x: 0.0, y: 0.0, z: 0.0)]

    return Scaffold(
      body: Center(
        child: Container(
          child: Text(
            output,
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
        ),
      ),
    );
  }
}
