import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'location_input_screen.dart';
import 'location_provider.dart';

void main() {
  runApp(MyApp());
}

//This app is developed by Usman. In this app we are playing with Google Map API.

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocationProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Location Based App',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home:
            LocationInputScreen(), // Navigate to MainScreen (LocationInputScreen)
      ),
    );
  }
}
