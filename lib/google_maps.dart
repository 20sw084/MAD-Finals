import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// add this in androidManifest.xml(after line 5)
// <meta-data android:name="com.google.android.geo.API_KEY"
//     android:value="AIzaSyDqIKgp0PFBw8Yp-SlXh1_8YABQ4Jd3Km"/>

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key,});


  @override
  State<GoogleMaps> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<GoogleMaps> {
  late GoogleMapController _mapController;

  _handleTap(LatLng point) {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: point, zoom: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Google Maps"),
      ),
      body: Center(
        child: GoogleMap(
          onTap: (argument) {
            _handleTap(argument);
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onMapCreated: (controller) {
            _mapController = controller;
          },
          initialCameraPosition: const CameraPosition(
            target: LatLng(37.4279, -122.0888),
            zoom: 12,
          ),
          markers: {
            const Marker(
              markerId: MarkerId("My-Marker"),
              icon: BitmapDescriptor.defaultMarker,
              position: LatLng(37.4279, -122.0888),
              infoWindow: InfoWindow(title: "My Marker"),
            )
          },
        ),
      ),
    );
  }
}

// End of class c