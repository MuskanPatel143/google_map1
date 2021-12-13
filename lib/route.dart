// ignore_for_file: constant_identifier_names, use_key_in_widget_constructors, prefer_collection_literals, prefer_final_fields, prefer_const_constructors, avoid_function_literals_in_foreach_calls, unnecessary_this, unused_field, non_constant_identifier_names, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Direction extends StatefulWidget {
  @override
  _DirectionState createState() => _DirectionState();
}

class _DirectionState extends State<Direction> {
  late LatLng SOURCE_LOCATION;
  late LatLng DEST_LOCATION = LatLng(23.022505, 72.571365);

  Completer<GoogleMapController> mapController = Completer();

  Set<Marker> _markers = Set<Marker>();
  List<Marker> markers = [];
  late LatLng currentLocation;
  late LatLng destinationLocation;
  LatLng? _initialPosition;
  Set<Polyline> _polylines = Set<Polyline>();
  bool isloading = false;
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  getCurrentLocation() async {
    setState(() {
      isloading = true;
    });
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    SOURCE_LOCATION = LatLng(position.latitude, position.longitude);
    this.setInitialLocation();
    initialize();
    setState(() {
      isloading = false;
      // _initialPosition = LatLng(position.latitude, position.longitude);
    });
    print(position.latitude);
    print(position.longitude);
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    WebView.platform = SurfaceAndroidWebView();
    polylinePoints = PolylinePoints();
  }

  initialize() {
    Marker firstMarker = Marker(
        markerId: MarkerId('chotila'),
        position: LatLng(22.423582, 71.194611),
        infoWindow: InfoWindow(title: 'chotila'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
    Marker secondMarker = Marker(
        markerId: MarkerId('limbdi'),
        position: LatLng(22.5688, 71.8019),
        infoWindow: InfoWindow(title: 'limbdi'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
    Marker thirdMarker = Marker(
        markerId: MarkerId('sayla'),
        position: LatLng(22.5488, 71.4863),
        infoWindow: InfoWindow(title: 'sayla'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
    Marker forthMarker = Marker(
        markerId: MarkerId('bagodara'),
        position: LatLng(22.6384, 72.2019),
        infoWindow: InfoWindow(title: 'bagodara'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));
    Marker fifthMarker = Marker(
        markerId: MarkerId('bavla'),
        position: LatLng(22.8365, 72.3628),
        infoWindow: InfoWindow(title: 'bavla'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed));

    setState(() {
      _markers.add(firstMarker);
      _markers.add(secondMarker);
      _markers.add(thirdMarker);
      _markers.add(forthMarker);
      _markers.add(fifthMarker);
    });
  }

  void setInitialLocation() {
    currentLocation =
        LatLng(SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude);
    destinationLocation =
        LatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              myLocationEnabled: true,
              compassEnabled: false,
              tiltGesturesEnabled: false,
              polylines: _polylines,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                mapController.complete(controller);
                showMarker();
                setPolylines();
              },
              initialCameraPosition: CameraPosition(
                target: SOURCE_LOCATION,
                zoom: 13,
              ),
            ),
    );
  }

  void showMarker() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: SOURCE_LOCATION,
        icon: BitmapDescriptor.defaultMarkerWithHue(30),
      ));

      _markers.add(Marker(
        markerId: MarkerId('destinationPin'),
        position: destinationLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(90),
      ));
    });
  }

  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyBbIz-Ck2_6s2I7JgplxNGznr6x6fjqouE",
        PointLatLng(SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude),
        PointLatLng(
            destinationLocation.latitude, destinationLocation.longitude));

    if (result.status == 'OK') {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        _polylines.add(Polyline(
            width: 10,
            polylineId: PolylineId('polyLine'),
            color: Color(0xFF08A5CB),
            points: polylineCoordinates));
      });
    }
  }
}
