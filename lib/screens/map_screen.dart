import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  LatLng _initialPosition = const LatLng(51.090791, 71.419574); // Astana

  @override
  void initState() {
    super.initState();
    _setInitialMarkers();
  }

  void _setInitialMarkers() {
    _markers.addAll([
      Marker(
        markerId: const MarkerId('marker1'),
        position: const LatLng(51.090791, 71.419574),
        infoWindow: const InfoWindow(title: 'Astana'),
      ),
      Marker(
        markerId: const MarkerId('marker2'),
        position: const LatLng(43.2389, 76.8897),
        infoWindow: const InfoWindow(title: 'Almaty'),
      ),
      Marker(
        markerId: const MarkerId('marker3'),
        position: const LatLng(42.3417, 69.5901),
        infoWindow: const InfoWindow(title: 'Shymkent'),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 12,
        ),
        markers: _markers,
        zoomGesturesEnabled: true,
        scrollGesturesEnabled: true,
        onMapCreated: (controller) => _mapController = controller,
        myLocationEnabled: false,
      ),
    );
  }
}