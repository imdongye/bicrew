import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  return position;
}

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
}

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  final bool _testMode = true;

  late Timer _timer;
  late GoogleMapController mapController;
  Set<Marker> markers = Set();

  double _lat = 37.27632;
  double _lon = 127.0483;

  double _maxCrewDistance = -1;
  double _allowDistance = 5;
  // 크루원 위치 정보(테스트용)
  List<double> _crewLat = [37.280115, 37.284169, 37.283001]; // 아주대 정문, 팔달관, 다산관
  List<double> _crewLon = [127.043639, 127.044408, 127.047262];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);

    getCurrentLocation().then((Position position) {
      setState(() {
        _lat = position.latitude;
        _lon = position.longitude;

        markers.add(
          Marker(
            markerId: MarkerId('my_location'),
            position: LatLng(_lat, _lon),
            infoWindow: InfoWindow(title: 'Me'),
          ),
        );
      });
    }).catchError((error) {
      // Handle error if any
      print('Error fetching location: $error');
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTimer(Timer timer) {
    getCurrentLocation().then((Position position) {
      setState(() {
        _lat = position.latitude;
        _lon = position.longitude;
        markers.add(
          Marker(
            markerId: MarkerId('my_location'),
            position: LatLng(_lat, _lon),
            infoWindow: InfoWindow(title: 'Me'),
          ),
        );
        if(_testMode){
          _lat = 37.352209;
          _lon = 127.043639;
        }
        for (var i = 0; i < _crewLat.length-2; i++) {
          var crewDistance =
              calculateDistance(_lat, _lon, _crewLat[i], _crewLon[i]);
          _maxCrewDistance = math.max(_maxCrewDistance, crewDistance);
          markers.add(
            Marker(
              markerId: MarkerId('member_${i + 1}'),
              position: LatLng(_crewLat[i], _crewLon[i]),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              infoWindow: InfoWindow(title: 'Member ${i + 1}'),
            ),
          );
        }
      });
    }).catchError((error) {
      // Handle error if any
      print('Error fetching location: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    const maxWidth = 400.0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(_lat, _lon),
                zoom: 16.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              markers: markers,
            ),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(width: 10),
                Text(
                  '가장 멀리있는 크루원과의 거리: ',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Container(
                  width: 150,
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text(
                      '${_maxCrewDistance.toStringAsFixed(1)}',
                      style: TextStyle(
                        fontSize: 16,
                        color:
                            _maxCrewDistance >= _allowDistance ? Colors.red : Colors.green,
                      ),
                    )
                  ]),
                ),
                Text(
                  '  km',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(width: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
