// ignore_for_file: constant_identifier_names, use_key_in_widget_constructors, prefer_collection_literals, prefer_final_fields, prefer_const_constructors, avoid_function_literals_in_foreach_calls, unnecessary_this, unused_field

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// const LatLng SOURCE_LOCATION = LatLng(13.652720, 100.493635);
// const LatLng DEST_LOCATION = LatLng(13.6640896, 100.4357021);

// class Direction extends StatefulWidget {
//   @override
//   _DirectionState createState() => _DirectionState();
// }

// class _DirectionState extends State<Direction> {
//   final Completer<GoogleMapController> mapController = Completer();

//   Set<Marker> _markers = Set<Marker>();
//   late LatLng currentLocation;
//   late LatLng destinationLocation;

//   Set<Polyline> _polylines = Set<Polyline>();
//   List<LatLng> polylineCoordinates = [];
//   late PolylinePoints polylinePoints;

//   @override
//   void initState() {
//     super.initState();
//     polylinePoints = PolylinePoints();
//     this.setInitialLocation();
//   }

//   void setInitialLocation() {
//     currentLocation =
//         LatLng(SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude);
//     destinationLocation =
//         LatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Direction"),
//       ),
//       body: GoogleMap(
//         myLocationEnabled: true,
//         compassEnabled: false,
//         tiltGesturesEnabled: false,
//         polylines: _polylines,
//         markers: _markers,
//         onMapCreated: (GoogleMapController controller) {
//           mapController.complete(controller);

//           showMarker();
//           setPolylines();
//         },
//         initialCameraPosition: CameraPosition(
//           target: SOURCE_LOCATION,
//           zoom: 13,
//         ),
//       ),
//     );
//   }

//   void showMarker() {
//     setState(() {
//       _markers.add(Marker(
//         markerId: MarkerId('sourcePin'),
//         position: currentLocation,
//         icon: BitmapDescriptor.defaultMarker,
//       ));

//       _markers.add(Marker(
//         markerId: MarkerId('destinationPin'),
//         position: destinationLocation,
//         icon: BitmapDescriptor.defaultMarkerWithHue(90),
//       ));
//     });
//   }

//   void setPolylines() async {
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         "AIzaSyBa-PJ9SwnKc9Ku0P-Af90mi-i9IKs2cYg",
//         PointLatLng(currentLocation.latitude, currentLocation.longitude),
//         PointLatLng(
//             destinationLocation.latitude, destinationLocation.longitude));

//     if (result.status == 'OK') {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });

//       setState(() {
//         _polylines.add(Polyline(
//             width: 10,
//             polylineId: PolylineId('polyLine'),
//             color: Color(0xFF08A5CB),
//             points: polylineCoordinates));
//       });
//     }
//   }
// }

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? mapController;
  double _originLatitude = 20.5937, _originLongitude = 78.9629;
  double _destLatitude = 37.090240, _destLongitude = -95.712891;
  // double _originLatitude = 26.48424, _originLongitude = 50.04551;
  // double _destLatitude = 26.46423, _destLongitude = 50.06358;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBD5afwWxQ1MpJ1TlDjZjIVLZ1VI-y4Xos";

  @override
  void initState() {
    super.initState();

    /// origin marker
    _addMarker(LatLng(_originLatitude, _originLongitude), "origin",
        BitmapDescriptor.defaultMarker);

    /// destination marker
    _addMarker(LatLng(_destLatitude, _destLongitude), "destination",
        BitmapDescriptor.defaultMarkerWithHue(90));
    _getPolyline();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(_originLatitude, _originLongitude), zoom: 15),
        myLocationEnabled: true,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: _onMapCreated,
        markers: Set<Marker>.of(markers.values),
        polylines: Set<Polyline>.of(polylines.values),
      )),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    setState(() {
      mapController = controller;
    });
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
        Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(_originLatitude, _originLongitude),
        PointLatLng(_destLatitude, _destLongitude),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}
