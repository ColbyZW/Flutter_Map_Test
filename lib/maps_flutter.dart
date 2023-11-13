import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FM_Page extends StatefulWidget {
  const FM_Page({super.key});

  @override
  State<FM_Page> createState() => _FMPageState();
}

class _FMPageState extends State<FM_Page> {
  final double latitude = 28.5384;
  final double longitude = -81.3789;
  late List<Marker> _markers;

  @override
  void initState(){
    _markers = createMarkers();
    super.initState();
  }

  List<Marker> createMarkers() {
    var rng = Random();
    List<Marker> markers = [];
    for (var i = 0; i < 50; i++) {
      double lat = latitude + (rng.nextDouble() * (2) + -1);
      double lon = longitude + (rng.nextDouble() * (2) + -1);
      markers.add(Marker(
        point: LatLng(lat, lon),
        width: 56,
        height: 56,
        child: customMarker(lat, lon)
      ));
    }
    return markers;
  }

  MouseRegion customMarker(lat, lon) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showInfoScreen(context, lat, lon),
        child: const Icon(Icons.person_pin_circle_rounded)
      )
    );
  }

  void _showInfoScreen(context, lat, lon) {
    showModalBottomSheet(useRootNavigator: true, context: context, builder: (BuildContext bc) {
      return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 1,
          child: Column(
            children: [
              CloseButton(
                onPressed: () => Navigator.of(context).pop(),
              ),
              Center(
                  child: Text("Marker ($lat, $lon)")
              )
            ],
          )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(latitude, longitude),
          initialZoom: 9.0
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: "com.app.demo",
          ),
          MarkerLayer(
            markers: _markers,
          )
        ]
    );
  }
}