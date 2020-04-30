import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
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

  void dispose() {
    super.dispose();
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
    return Container(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Your Location"),
              Text(
                _currentPosition.toString(),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ]),
      ),
    );
  }
}
