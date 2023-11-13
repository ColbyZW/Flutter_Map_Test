import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class OSM_Page extends StatefulWidget {
  const OSM_Page({super.key, required this.title});

  final String title;

  @override
  State<OSM_Page> createState() => _OSMPageState();
}

class _OSMPageState extends State<OSM_Page> with OSMMixinObserver {
  final double latitude = 28.5384;
  final double longitude = -81.3789;
  late MapController controller;

  @override
  void initState() {
    controller = MapController(
        initPosition: _ucf
    );

    controller.addObserver(this);
    super.initState();
  }

  static final GeoPoint _ucf = GeoPoint(
      latitude: 28.6024,
      longitude: -81.2001
  );

  @override
  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
      await initializeMap();
    }
  }

  Future<void> initializeMap() async {
    var rng = Random();
    for (var i = 0; i < 50; i++) {
      double lat = latitude + (rng.nextDouble() * (2) + -1);
      double lon = longitude + (rng.nextDouble() * (2) + -1);
      var point = GeoPoint(
          latitude: lat,
          longitude: lon
      );
      await controller.addMarker(point);
    }
  }

  void _showInfoScreen(context, point) {
    showModalBottomSheet(useRootNavigator: true, context: context, builder: (BuildContext bc) {
      return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 1,
          child: Column(
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: CloseButton(
                  onPressed: () => Navigator.of(context).pop(),
                )
              ),
              Center(
                  child: Text("Marker (${point.latitude}, ${point.longitude})")
              )
            ],
          )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: OSMFlutter(
            controller: controller,
            osmOption: OSMOption(
              zoomOption: const ZoomOption(
                  initZoom: 9,
                  minZoomLevel: 3,
                  maxZoomLevel: 15,
                  stepZoom: 1.0
              ),
              markerOption: MarkerOption(
                  defaultMarker: const MarkerIcon(
                      icon: Icon(
                          Icons.person_pin_circle_rounded,
                          color: Colors.deepOrange,
                          size: 56
                      )
                  )
              ),
              isPicker: true,
            ),
            onGeoPointClicked: (point) => _showInfoScreen(context, point),
          )
      ),
    );
  }
}
