import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_location_picker/flutter_google_location_picker.dart';

import 'Slot.dart';

class MapSample extends StatefulWidget {
  List<Slot> slots;

  MapSample(this.slots);

  // const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState(slots);
}

class MapSampleState extends State<MapSample> {
  @override
  void initState() {
    for(var s in slots){
      _createPolylines(40.9,20.4,s.location.latitude,s.location.latitude);

    }
    print("here "+polylines.toString());
    super.initState();
  }
  MapSampleState(this.slots);

  late PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};

  List<Slot> slots = [];
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(41.9, 21.4),
    zoom: 14.4746,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        markers: slots
            .map((e) => Marker(
                  markerId: MarkerId(e.name+e.dateTime.toString()),
                  position: LatLng(e.location.latitude, e.location.longitude),
                  infoWindow: InfoWindow(
                    title: e.name,
                  ),
                  icon: BitmapDescriptor.defaultMarker, //Icon for Marker
                ))
            .toSet(),
        // polylines: Set<Polyline>.of(polylines.values),
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  // Create the polylines for showing the route between two places
  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    polylineCoordinates=[];
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();
    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCOTvtj5-rnF0z1k9yETS79kDax8Qzhvio", // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.transit,
    );
    print("RESULT ` "+result.toString());
    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {

      result.points.forEach((PointLatLng point) {
        print("POINT` "+point.toString());
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    // Defining an ID
    PolylineId id = PolylineId((polylines.length+1).toString());
    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    // Adding the polyline to the map
    polylines[id] = polyline;

  }
}
