import 'package:field_flow/model/location_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Pathmap extends StatefulWidget {
  final List<LocationModel> locationList; // (lat, lng, duration)

  const Pathmap({super.key, required this.locationList});

  @override
  State<Pathmap> createState() => _PathmapState();
}

class _PathmapState extends State<Pathmap> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _processLocations();
  }

  void _processLocations() {
    List<LatLng> pathPoints = [];

    for (var location in widget.locationList) {
      pathPoints.add(LatLng(location.latitude, location.longitude));

      if (location.duration.inMinutes >= 1) {
        _markers.add(Marker(
          markerId: MarkerId('${location.latitude},${location.latitude}'),
          position: LatLng(location.latitude, location.longitude),
          infoWindow: InfoWindow(
            title: 'Stayed Here',
            snippet: '${location.duration.inMinutes} minutes',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ));
      }
    }

    _polylines.add(Polyline(
      polylineId: const PolylineId('user_path'),
      color: Colors.pink,
      width: 5,
      points: pathPoints,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Path Map")),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: widget.locationList.isNotEmpty
              ? LatLng(widget.locationList[0].latitude, widget.locationList[0].longitude)
              : const LatLng(0, 0),
          zoom: 14,
        ),
        markers: _markers,
        polylines: _polylines,
      ),
    );
  }
}
