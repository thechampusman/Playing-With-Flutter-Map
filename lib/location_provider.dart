import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class LocationProvider with ChangeNotifier {
  String? _locationName; //Variables
  double? _latitude;
  double? _longitude;

  String? get locationName => _locationName;
  double? get latitude => _latitude;
  double? get longitude => _longitude;

  // This function updates the location based on the name (address)
  Future<void> setLocation(String location) async {
    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        //variables updated here with current data or input data
        _latitude = locations[0].latitude;
        _longitude = locations[0].longitude;
        _locationName = location;
        notifyListeners(); // Notify listeners about the update
      }
    } catch (error) {
      throw 'Location not found';
    }
  }

  // Updates current location based on coordinates
  void setLocationFromCoordinates(double lat, double lng, String locationName) {
    _latitude = lat;
    _longitude = lng;
    _locationName = locationName;
    notifyListeners(); // Notify listeners about the update
  }
}
