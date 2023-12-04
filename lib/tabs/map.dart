import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("맵뷰입니다."),
        GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(37.43296265331129, -122.08832357078792)),
        ),
      ],
    );
  }
}
