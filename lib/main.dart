import 'dart:async';
import 'package:flutter/material.dart';

import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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

  Coordinates get coordinates => null;
  var lokasi = "Loc";
  var city = "Loc";

  Map<String, double> currentLocation = new Map();
  StreamSubscription<Map<String, double>> locationSubscription;
  Location location = new Location();
  String error;

    void initPlatformState() async {
    Map<String, double> myLocation;
    try {
      myLocation = await location.getLocation();
      error = "";
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = "Permission Denied";
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            "Permission denied - please ask the user to enable it from setting app";
      }
      myLocation = null;
    }
    setState(() {
      currentLocation = myLocation;
    });
  }

    Future<List<Address>> findAddressesFromCoordinates() async {
    // From coordinates
    final coordinates = new Coordinates(
        currentLocation['latitude'], currentLocation['longitude']);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
//    print(coordinates);
//    print(currentLocation['latitude']);
//    print(currentLocation['longitude']);
    var get = addresses.first;
      lokasi = "${get.featureName}";
      city = "${get.locality}";
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
        currentLocation['latitude'] = 0.0;
    currentLocation['longitude'] = 0.0;
    initPlatformState();
    locationSubscription =
        location.onLocationChanged().listen((Map<String, double> result) {
        setState(() {
          currentLocation = result;
          findAddressesFromCoordinates();
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text('$lokasi, $city',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
