import 'dart:async';

import 'package:dr_fit/features/near_gyms/user_location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class GymsScreen extends StatefulWidget {
  const GymsScreen({super.key});

  @override
  State<GymsScreen> createState() => _GymsScreenState();
}

class _GymsScreenState extends State<GymsScreen> {
  final _mapController = Completer<GoogleMapController>();
  LatLng? _currentLocation;
  final Set<Marker> _markers = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadGyms();
  }

  Future<void> _loadGyms() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final position = await LocationServices.getCurrentLocation();
      _currentLocation = LatLng(position.latitude, position.longitude);

      final gyms = await LocationServices.fetchNearbyGyms(
        position.latitude,
        position.longitude,
      );

      _markers.clear();
      _markers.add(_userMarker());
      _markers.addAll(_gymMarkers(gyms));

      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Marker _userMarker() => Marker(
    markerId: const MarkerId('user'),
    position: _currentLocation!,
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    infoWindow: const InfoWindow(title: 'موقعك الحالي'),
  );

  Set<Marker> _gymMarkers(List<PlacesSearchResult> gyms) {
    return gyms.map((gym) {
      final loc = gym.geometry?.location;
      return Marker(
        markerId: MarkerId(gym.placeId),
        position: LatLng(loc!.lat, loc.lng),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(title: gym.name),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الجيمات القريبة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadGyms,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadGyms,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      )
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLocation ?? const LatLng(0, 0),
          zoom: 14,
        ),
        markers: _markers,
        myLocationEnabled: true,
        onMapCreated: _mapController.complete,
      ),
    );
  }
}
