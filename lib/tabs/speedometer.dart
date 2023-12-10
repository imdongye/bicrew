import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:bicrew/charts/pie_chart.dart';
import 'package:bicrew/data.dart';
import 'package:bicrew/finance.dart';
import 'package:bicrew/tabs/sidebar.dart';
import 'package:bicrew/colors.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async {
  LocationPermission permission = await Geolocator.requestPermission();
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  return position;
}

// 위도와 경도를 이용하여 두 지점 간의 거리를 계산하는 함수
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371.0; // 지구 반지름 단위:킬로미터

  if (lat1 == lon1 && lat2 == lon2) {
    return 0.0;
  }

  lat1 = _degreesToRadians(lat1);
  lon1 = _degreesToRadians(lon1);
  lat2 = _degreesToRadians(lat2);
  lon2 = _degreesToRadians(lon2);
  double distance = math.acos(math.sin(lat1) * math.sin(lat2) +
          math.cos(lat1) * math.cos(lat2) * math.cos(lon2 - lon1)) *
      earthRadius;
  return distance; // 단위:킬로미터
}

double _degreesToRadians(double degrees) {
  return degrees * (math.pi / 180);
}

class SpeedometerView extends StatefulWidget {
  const SpeedometerView({Key? key}) : super(key: key);

  final double kiloPerHour = 20.0;

  @override
  State<SpeedometerView> createState() => SpeedometerViewState();
}

class SpeedometerViewState extends State<SpeedometerView> {
  bool _testMode = true;

  late Timer _timer;
  late Position _previousPosition;
  int _seconds = 0;
  int _realtime = 0;
  bool _isRunning = false;

  double _currentSpeed = 0.0;
  double _averageSpeed = 0.0;
  double _maxSpeed = 0.0;
  double _distance = 0.0;
  double _sumDistance = 0.0;

  double _latitude = 0.0;
  double _longitude = 0.0;

  double _pLatitude = 0.0;
  double _pLongitude = 0.0;

  double _test = 0.0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTimer(Timer timer) {
    _realtime++;
    _pLatitude = _latitude;
    _pLongitude = _longitude;
    getCurrentLocation().then((Position position) {
      setState(() {
        _latitude = position.latitude;
        //_latitude += _realtime * _realtime / 10000;
        _longitude = position.longitude;
      });
    }).catchError((error) {
      // Handle error if any
      print('Error fetching location: $error');
    });

    if (_realtime > 0) {
      _distance =
          calculateDistance(_latitude, _longitude, _pLatitude, _pLongitude);
      if (_testMode) {
        _distance = _realtime / 3600;
      }
    }

    if (_isRunning) {
      _seconds++;
      if (!_distance.isNaN) {
        _sumDistance += _distance;
        _currentSpeed = _distance * 3600;
        _maxSpeed = math.max(_maxSpeed, _currentSpeed);
        _averageSpeed = _sumDistance * 3600 / _seconds;
        _test = _realtime + 0.0;
      }
    }
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
  }

  void _pauseTimer() {
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _seconds = 0;
      _realtime = 0;
      _sumDistance = 0;
      _maxSpeed = 0;
    });
  }

  String _formatTime(int seconds) {
    Duration duration = Duration(seconds: seconds);
    return '${(duration.inHours).toString().padLeft(2, '0')}:'
        '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:'
        '${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final items = DummyDataService.getAccountDataList(context);
    const maxWidth = 400.0;

    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: math.min(
              MediaQuery.of(context).size.width * 0.9,
              maxWidth,
            ),
          ),
          child: RallyPieChart(
            heroLabel: "km/h",
            heroAmount: _currentSpeed,
            wholeAmount: 60.0,
            segments: buildSegmentsFromAccountItems(items),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          height: 1,
          constraints: BoxConstraints(maxWidth: maxWidth),
          color: BicrewColors.inputBackground,
        ),
        Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          color: BicrewColors.cardBackground,
          child: Column(
            children: [
              Text(
                'Time: ${_formatTime(_seconds)}',
                style: TextStyle(fontSize: 18),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _startTimer,
                    child: Text('Start'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _pauseTimer,
                    child: Text('Pause'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _resetTimer,
                    child: Text('Reset'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Text('위도: ${_latitude.toStringAsFixed(4)}'),
        Text('경도: ${_longitude.toStringAsFixed(4)}'),
        Text('이동 거리: ${_sumDistance.toStringAsFixed(3)} km'),
        Text('최대 속도: ${_maxSpeed.toStringAsFixed(1)} km/h'),
        Text('평균 속도: ${_averageSpeed.toStringAsFixed(1)} km/h'),
      ],
    );
  }
}
