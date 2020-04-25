import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final CollectionReference locationCollection =
      Firestore.instance.collection('Location');

  Position _currentPosition;

  var timeout = const Duration(seconds: 3);
  var ms = const Duration(milliseconds: 1);

  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 2), (Timer _) {
      getLocation();
      updateData(_currentPosition.toString(), 1);
    });
  }

  Future getLocation() async {
    Position position;
    position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    setState(() {
      _currentPosition = position;
    });
  }

  Future updateData(String position, int weight) async {
    var data = {'positon': position, 'weight': weight};

    return await locationCollection.add(data).then((ref) {
      print(data);
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(_currentPosition.toString());
  }
}
