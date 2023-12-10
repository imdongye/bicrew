import 'package:flutter/material.dart';
// import 'package:window_manager/window_manager.dart';
import 'app.dart';

void main() async {
  // 플렛폼 채널 바인딩
  WidgetsFlutterBinding.ensureInitialized();
  // LocationPermission permission = await Geolocator.requestPermission();

  // // 윈도우에서 창크기 모바일에 맞게 초기화
  // await windowManager.ensureInitialized();
  // WindowOptions windowOptions = const WindowOptions(
  //   size: Size(520, 1000),
  // );
  // windowManager.waitUntilReadyToShow(windowOptions, () async {
  //   await windowManager.show();
  //   await windowManager.focus();
  // });

  // runApp(const MainApp());
  runApp(const BicrewApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
