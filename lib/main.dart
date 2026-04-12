import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool isReady = false;

  double altidude = 0;
  double speed = 0;

  // 纬度
  double latitude = 0;
  // 经度
  double longitude = 0;

  StreamSubscription<Position>? positionStream;

  Future<void> init() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    
    if (permission == LocationPermission.deniedForever) return;

    setState(() => isReady = true);
    
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 1,
      ),
    ).listen((Position position) {
      setState(() {
        speed = position.speed > 0 ? position.speed * 3.6 : 0;
        altidude = position.altitude;
        latitude = position.latitude;
        longitude = position.longitude;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  String formatLocation() {
    String latDir = latitude >= 0 ? 'N' : 'S';
    String lonDir = longitude >= 0 ? 'E' : 'W';

    double latAbs = latitude.abs();
    int latDeg = latAbs.toInt();
    double latMinDec = (latAbs - latDeg) * 60;
    int latMin = latMinDec.toInt();
    double latSec = (latMinDec - latMin) * 60;

    double lonAbs = longitude.abs();
    int lonDeg = lonAbs.toInt();
    double lonMinDec = (lonAbs - lonDeg) * 60;
    int lonMin = lonMinDec.toInt();
    double lonSec = (lonMinDec - lonMin) * 60;

    return '$latDeg°$latMin′${latSec.toInt()}″ $latDir, '
        '$lonDeg°$lonMin′${lonSec.toInt()}″ $lonDir';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            mainAxisSize: .min,
            children: [
              Padding(
                padding: .only(top: 50),
                child: Text(
                  '${(speed).toInt()} km/h',
                  style: TextStyle(
                    fontSize: 40,
                    color: isReady ? Colors.black : Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: .only(top: 20),
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      size: 18,
                    ),
                    const SizedBox(width: 5,),
                    Text(
                      formatLocation(),
                    ),
                  ]
                )
              ),
              Padding(
                padding: .only(top: 5),
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    Icon(
                      Icons.landscape_rounded,
                      size: 18,
                    ),
                    const SizedBox(width: 5,),
                    Text(
                      '${(altidude).toInt()} m',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
