import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'map_screen.dart';
import 'location_provider.dart';

class LocationInputScreen extends StatefulWidget {
  @override
  _LocationInputScreenState createState() => _LocationInputScreenState();
}

class _LocationInputScreenState extends State<LocationInputScreen> {
  final _locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // screenHeight and screenWidth variables for MediaQuery to make responsive screen
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Playing With",
                      style: TextStyle(fontSize: screenHeight * 0.025),
                    ),
                    Text(
                      "Maps In Flutter",
                      style: TextStyle(
                          fontSize: screenHeight * 0.05,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                // Location input field
                Container(
                  padding: EdgeInsets.only(left: 10),
                  width: screenWidth / 1.2,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6FB),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  //TextFieldForm for input to get user's desired location
                  child: TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.location_on, color: Colors.grey),
                        labelText: 'Enter Location',
                        border: InputBorder.none),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a location';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 30),

                // Button to find desired location

                Container(
                  height: screenHeight * 0.07,
                  width: screenWidth / 1.2,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        String location = _locationController.text;
                        try {
                          await Provider.of<LocationProvider>(context,
                                  listen: false)
                              .setLocation(location);
                          Navigator.of(context).push(MaterialPageRoute(
                            // Navigate to the MapScreen
                            builder: (context) => MapScreen(),
                          ));
                        } catch (error) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text('Location not found. Please try again.'),
                          ));
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: screenWidth * 0.02,
                        ),
                        Text(
                          "Search Location On Map",
                          style: TextStyle(
                              fontSize: screenHeight * 0.02,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text("OR"),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Button to get user's current location

                Container(
                  height: screenHeight * 0.07,
                  width: screenWidth / 1.2,
                  child: ElevatedButton(
                    onPressed: _useCurrentLocation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.my_location,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: screenWidth * 0.02,
                        ),
                        Text(
                          "Get Your Current Location",
                          style: TextStyle(
                              fontSize: screenHeight * 0.02,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to handle current location
  Future<void> _useCurrentLocation() async {
    // Show the loading dialog
    _showLoadingDialog(context);

    try {
      Position? position = await _getCurrentLocation();
      if (position != null) {
        Provider.of<LocationProvider>(context, listen: false)
            .setLocationFromCoordinates(
                position.latitude, position.longitude, 'Your Location');

        // Dismiss the loading dialog before navigation
        Navigator.of(context, rootNavigator: true).pop();

        // Navigate to the MapScreen
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MapScreen(),
        ));
      }
    } catch (e) {
      // Dismiss the loading dialog if there was an error
      Navigator.of(context, rootNavigator: true).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get current location')),
      );
    }
  }

  // Show loading dialog when fetching location
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismiss by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Fetching location...'),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to get the user's current location
  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Navigator.of(context, rootNavigator: true)
          .pop(); // Dismiss loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Location services are disabled. Please enable location services.')),
      );
      return null;
    }

    // Check and request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Navigator.of(context, rootNavigator: true)
            .pop(); // Dismiss loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied.')),
        );
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Navigator.of(context, rootNavigator: true)
          .pop(); // Dismiss loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Location permissions are permanently denied. Please enable location permissions.')),
      );
      return null;
    }

    return await Geolocator.getCurrentPosition(
        // Get the current location
        desiredAccuracy: LocationAccuracy.high);
  }
}
