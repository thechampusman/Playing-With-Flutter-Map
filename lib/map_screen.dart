import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'location_provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _controller;
  MapType _currentMapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);

    // Set marker based on the user input
    final marker = Marker(
      markerId: MarkerId('userLocation'),
      position: LatLng(locationProvider.latitude!, locationProvider.longitude!),
      infoWindow: InfoWindow(title: locationProvider.locationName),
    );

    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target:
                LatLng(locationProvider.latitude!, locationProvider.longitude!),
            zoom: 14,
          ),
          markers: {marker},
          mapType: _currentMapType,
          onMapCreated: (controller) {
            _controller = controller;
          },
        ),
        Positioned(
          top: 40,
          left: 16,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: IconButton(
              color: Colors.white,
              icon: Icon(Icons.arrow_back,
                  color: Colors.black.withOpacity(0.5), size: 30),
              onPressed: () {
                Navigator.of(context).pop();
              },
              tooltip: 'Back',
              splashRadius: 24,
            ),
          ),
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white.withOpacity(0.7),
        onPressed: () {
          _showMapTypeDialog(context);
        },
        child: Icon(
          Icons.map,
          color: Colors.black.withOpacity(0.8),
        ),
        tooltip: 'Change Map Type',
      ),
    );
  }

  // Dialog to select map type
  void _showMapTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Map Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Normal'),
                onTap: () {
                  setState(() {
                    _currentMapType = MapType.normal;
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Satellite'),
                onTap: () {
                  setState(() {
                    _currentMapType = MapType.satellite;
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Terrain'),
                onTap: () {
                  setState(() {
                    _currentMapType = MapType.terrain;
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Hybrid'),
                onTap: () {
                  setState(() {
                    _currentMapType = MapType.hybrid;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
