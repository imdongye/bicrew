import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  late GoogleMapController mapController;
  Set<Marker> markers = Set();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
      ),
      body: Column(
        children: [
          Text("맵 뷰"),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(37.2811, 127.0508),
                zoom: 12.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  mapController = controller;
                  markers.add(
                    Marker(
                      markerId: MarkerId('1'),
                      position: LatLng(37.2811, 127.0508),
                      infoWindow: InfoWindow(title: 'My Marker'),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
