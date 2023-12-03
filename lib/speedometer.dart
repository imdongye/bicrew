import 'package:flutter/material.dart';
import 'package:bicrew/app.dart';
import 'package:bicrew/colors.dart';

class SpeedometerPage extends StatefulWidget {
  const SpeedometerPage({super.key});

  @override
  State<SpeedometerPage> createState() => _SpeedometerPageState();
}

class _SpeedometerPageState extends State<SpeedometerPage> {
  void _joinGroup() {
    Navigator.of(context).restorablePushNamed(BicrewApp.loginRoute);
  }

  void _goSpeedometer() {
    Navigator.of(context).restorablePushNamed(BicrewApp.sppedometerRoute);
  }

  void _goHistory() {
    Navigator.of(context).restorablePushNamed(BicrewApp.homeRoute); // todo
  }

  void _goSettings() {
    Navigator.of(context).restorablePushNamed(BicrewApp.loginRoute); // todo
  }

  final List<String> entries = <String>['A', 'B', 'C', 'd'];
  final List<int> colorCodes = <int>[600, 500, 100, 10];

  @override
  Widget build(BuildContext context) {
    const double rowMaxWidth = 450;
    const double columnPadding = 45;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('🚵 속도계 페이지'),
        backgroundColor: const Color(0xFF26282F),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: rowMaxWidth,
          child: Column(
            children: [
              const SizedBox(height: 8),
              const Divider(color: BicrewColors.white60),
              const SizedBox(height: columnPadding),
              _FilledButton(text: "속도계 모드", onTap: _goSpeedometer),
              const SizedBox(height: columnPadding),
              _FilledButton(text: "기록 보기", onTap: _goHistory),
              const SizedBox(height: columnPadding),
              _FilledButton(text: "설정", onTap: _goSettings),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilledButton extends StatelessWidget {
  const _FilledButton({required this.text, required this.onTap, this.iconData});

  final String text;
  final VoidCallback onTap;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: const Size(200, 0),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        foregroundColor: Colors.black,
        backgroundColor: BicrewColors.buttonColor,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onTap,
      child: (iconData != null)
          ? Row(
              children: [
                Icon(iconData),
                const SizedBox(width: 6),
                Text(text),
              ],
            )
          : Text(text),
    );
  }
}
