import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:speeder/views/settings_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
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

  bool flip=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Transform.flip(
            flipY: flip,
            child: Center(
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .center,
                // mainAxisSize: .min,
                children: [
                  Padding(
                    padding: .only(top: 50),
                    child: Row(
                      mainAxisSize: .min,
                      crossAxisAlignment: .end,
                      children: [
                        Text(
                          '${(speed).toInt()}',
                          style: TextStyle(
                            height: 1.0,
                            fontSize: 50,
                          ),
                        ),
                        Padding(
                          padding: .only(left: 5),
                          child: Text(
                            'km/h',
                          ),
                        )
                      ],
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
          Positioned(
            top: MediaQuery.of(context).padding.top+20,
            right: 20,
            child: IconButton(
              onPressed: (){
                Get.to(() => SettingsView());
              }, 
              icon: Icon(Icons.settings_rounded)
            )
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top+20,
            left: 20,
            child: IconButton(
              onPressed: (){
                setState(() {
                  flip = !flip;
                });
              }, 
              icon: Icon(Icons.compare_arrows_rounded)
            )
          )
        ],
      ),
    );
  }
}