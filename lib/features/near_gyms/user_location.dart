import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';

class LocationServices {
  static const String _apiKey = 'AIzaSyABKSTf-9-q9e4bOiyYHl4m3pEnoet6ofk';
  static final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: _apiKey);

  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Location services disabled');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions permanently denied');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
  }

  static Future<List<PlacesSearchResult>> fetchNearbyGyms(double lat, double lng) async {
    final response = await _places.searchNearbyWithRadius(
      Location(lat: lat, lng: lng),
      5000, // 5km
      type: 'gym',
      keyword: 'gym|fitness|رياضة',
    );

    if (response.status == 'OK') {
      return response.results;
    } else {
      throw Exception('Failed to fetch gyms: ${response.errorMessage}');
    }
  }
}
