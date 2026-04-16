import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gps_tracker/utils/cals.dart';
import 'package:gps_tracker/views/settings_view.dart';
import 'package:gps_tracker/views/track_view.dart';

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

  // 最高速度
  double maxSpeed = 0;

  // 时间
  int seconds = 0;

  Timer? timer;

  StreamSubscription<Position>? positionStream;

  bool flip=false;
  bool tracking=false;
  double distance=0.0;
  Position? lastPosition;

  void trackHandler(Position position){
    if(!tracking){
      return;
    }
    if (lastPosition != null) {
      double len = Geolocator.distanceBetween(
        lastPosition!.latitude,
        lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );
      distance += len;
    }
    lastPosition = position;
    if(position.speed * 3.6 > maxSpeed){
      setState(() {
        maxSpeed = position.speed > 0 ? position.speed * 3.6 : 0;
      });
    }
  }

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
      trackHandler(position);
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
    timer?.cancel();
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
                  ),
                  if(tracking) Padding(
                    padding: .only(top: 20),
                    child: Row(
                      mainAxisSize: .min,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.route,
                          size: 18,
                        ),
                        const SizedBox(width: 5,),
                        Text(
                          formatDistance(distance),
                        ),
                      ]
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (tracking) {
            timer?.cancel();
            setState(() {
              tracking = false;
            });
            await Get.to(() => TrackView(
              maxSpeed: maxSpeed,
              distance: distance,
              seconds: seconds,
            ));
            if (mounted) {
              setState(() {
                distance = 0;
                lastPosition = null;
                maxSpeed = 0;
                seconds = 0;
              });
            }
          } else {
            setState(() {
              tracking = true;
            });

            timer = Timer.periodic(Duration(seconds: 1), (t) {
              setState(() {
                seconds++;
              });
            });
          }
        },
        child: FaIcon(
          tracking ? FontAwesomeIcons.stop : FontAwesomeIcons.route,
          size: 20,
        ),
      ),
    );
  }
}