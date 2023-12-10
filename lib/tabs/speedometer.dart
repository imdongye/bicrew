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

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
}

class SpeedometerView extends StatefulWidget {
  const SpeedometerView({Key? key}) : super(key: key);

  @override
  State<SpeedometerView> createState() => SpeedometerViewState();
}

class SpeedometerViewState extends State<SpeedometerView> {
  final bool _testMode = true;

  late Timer _timer;
  int _seconds = 0;
  int _realtime = 0;
  bool _isRunning = false;

  double _currentSpeed = 0.0;
  double _pCurrentSpeed = 0.0;
  double _averageSpeed = 0.0;
  double _maxSpeed = 0.0;
  double _distance = 0.0;
  double _sumDistance = 0.0;

  double _latitude = 0.0;
  double _longitude = 0.0;

  double _pLatitude = 0.0;
  double _pLongitude = 0.0;

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
    _pCurrentSpeed = _currentSpeed;
    getCurrentLocation().then((Position position) {
      setState(() {
        _latitude = position.latitude;
        if (_testMode) {
          _latitude += _realtime * _realtime / 1000000000;
        }
        _longitude = position.longitude;

        if (_realtime > 1) {
          _distance =
              calculateDistance(_latitude, _longitude, _pLatitude, _pLongitude);
        }

        if (_isRunning) {
          _seconds++;
          _currentSpeed = _distance * 3600;
          if (_currentSpeed > _averageSpeed * 20 && _currentSpeed > 200) {
            // 속도가 비정상적으로 높을 때 예외 처리
            _currentSpeed = _pCurrentSpeed;
            _sumDistance += _pCurrentSpeed / 3600;
          } else {
            // 정상적인 상황에서 속도 처리
            _sumDistance += _distance;
            _maxSpeed = math.max(_maxSpeed, _currentSpeed);
          }
          _averageSpeed = _sumDistance * 3600 / _seconds;
        }
      });
    }).catchError((error) {
      // Handle error if any
      print('Error fetching location: $error');
    });
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
      _averageSpeed = 0;
      _currentSpeed = 0;
      _pCurrentSpeed = 0;
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

    List<AccountData> speed = [
      AccountData(
        name: '1', // 예시 이름
        primaryAmount: 100, // 예시 주요 금액
        accountNumber: '1234-5678-9012', // 예시 계좌 번호
      ),
      AccountData(
        name: '2', // 예시 이름
        primaryAmount: math.min(_currentSpeed, 60),
        //primaryAmount: 100-_currentSpeed, // 예시 주요 금액
        accountNumber: '1234-5678-9012', // 예시 계좌 번호
      ),
      AccountData(
        name: '3', // 예시 이름
        primaryAmount: math.max(_currentSpeed-60, 0),
        //primaryAmount: 100-_currentSpeed, // 예시 주요 금액
        accountNumber: '1234-5678-9012', // 예시 계좌 번호
      ),
    ];
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
            heroAmount: double.parse(_currentSpeed.toStringAsFixed(2)),
            wholeAmount: 60,
            segments: buildSegmentsFromAccountItems(speed),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          color: BicrewColors.inputBackground,
        ),
        Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          color: BicrewColors.cardBackground,
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '위도: ${_latitude.toStringAsFixed(5)}',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(width: 140),
                  Text(
                    '경도: ${_longitude.toStringAsFixed(5)}',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 1),
              Container(
                padding: EdgeInsets.all(8), // 텍스트 주변으로 여백 추가
                child: Column(
                  children: [
                    Text(
                      '주행시간',
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey), // Time 텍스트 스타일 변경
                    ),
                    Text(
                      _formatTime(_seconds),
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.green, width: 1.5), // 테두리 색과 굵기 설정
                      borderRadius: BorderRadius.circular(10), // 테두리 둥글기 설정
                    ),
                    width: 100,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        Text(
                          '평균 속도',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey), // Time 텍스트 스타일 변경
                        ),
                        Text(
                          '${_averageSpeed.toStringAsFixed(1)}',
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          'km/h',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey), // Time 텍스트 스타일 변경
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.green, width: 1.5), // 테두리 색과 굵기 설정
                      borderRadius: BorderRadius.circular(10), // 테두리 둥글기 설정
                    ),
                    width: 100,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      children: [
                        Text(
                          '이동 거리',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey), // Time 텍스트 스타일 변경
                        ),
                        Text(
                          '${_sumDistance.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          'km',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey), // Time 텍스트 스타일 변경
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.green, width: 1.5), // 테두리 색과 굵기 설정
                      borderRadius: BorderRadius.circular(10), // 테두리 둥글기 설정
                    ),
                    width: 100,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        Text(
                          '최대 속도',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey), // Time 텍스트 스타일 변경
                        ),
                        Text(
                          '${_maxSpeed.toStringAsFixed(1)}',
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          'km/h',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey), // Time 텍스트 스타일 변경
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _startTimer,
                    style: _isRunning
                        ? ElevatedButton.styleFrom(
                            primary: Colors
                                .cyanAccent) // _isRunning이 true일 때 버튼 색상을 빨간색으로 변경
                        : ElevatedButton
                            .styleFrom(), // _isRunning이 false일 때 기본 스타일 유지
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
              SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
