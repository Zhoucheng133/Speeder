import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gps_tracker/utils/cals.dart';

class TrackView extends StatefulWidget {

  final double maxSpeed;
  final double distance;
  final int seconds;

  const TrackView({super.key, required this.maxSpeed, required this.distance, required this.seconds});

  @override
  State<TrackView> createState() => _TrackViewState();
}

class _TrackViewState extends State<TrackView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text('track'.tr),
      ),
      body: Center(
        child: Column(
          mainAxisSize: .min,
          children: [
            Row(
              mainAxisSize: .min,
              children: [
                FaIcon(
                  FontAwesomeIcons.route,
                  size: 40,
                ),
                SizedBox(width: 15),
                Text(
                  formatDistance(widget.distance),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisSize: .min,
              children: [
                SizedBox(
                  width: 130,
                  child: Row(
                    mainAxisAlignment: .end,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.gaugeSimpleHigh,
                        size: 15,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 10),
                      Text("maxSpeed".tr),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: Text(
                    "${widget.maxSpeed.toStringAsFixed(2)} km/h",
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisSize: .min,
              children: [
                SizedBox(
                  width: 130,
                  child: Row(
                    mainAxisAlignment: .end,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.gaugeSimple,
                        size: 15,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 10),
                      Text("averageSpeed".tr),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: Text(
                    widget.distance > 0
                        ? "${(widget.distance / widget.seconds * 3.6).toStringAsFixed(2)} km/h"
                        : "0.0 km/h",
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisSize: .min,
              children: [
                SizedBox(
                  width: 130,
                  child: Row(
                    mainAxisAlignment: .end,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.solidClock,
                        size: 15,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: 10),
                      Text("time".tr),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: Text(
                    formatTime(widget.seconds),
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}