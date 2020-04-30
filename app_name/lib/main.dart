import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:app_name/home.dart';
import 'package:app_name/map.dart';

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
  int currentIndex = 0;
  final List<Widget> children = [
    Home(),
    MapScreen(),
  ];

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white30,
          iconSize: 20,
          onTap: onTapped,
          currentIndex: currentIndex,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('Map')),
          ]),
    );
  }

  void onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
