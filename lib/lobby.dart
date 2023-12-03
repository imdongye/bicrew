import 'package:flutter/material.dart';
import 'package:bicrew/app.dart';
import 'package:bicrew/colors.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({super.key});

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  void _joinGroup() {
    Navigator.of(context).restorablePushNamed(BicrewApp.loginRoute);
  }

  void _makeGroup() {
    Navigator.of(context).restorablePushNamed(BicrewApp.loginRoute);
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
        title: const Text('🚵 로비 페이지'),
        backgroundColor: const Color(0xFF26282F),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: rowMaxWidth,
          child: Column(
            children: [
              const SizedBox(height: 10),
              _JoinGroupRow(onTap: _joinGroup),
              const SizedBox(height: 8),
              const Divider(color: BicrewColors.white60),
              const SizedBox(height: columnPadding),
              _FilledButton(text: "크루 만들기", onTap: _makeGroup),
              const SizedBox(height: columnPadding),
              _FilledButton(text: "속도계 모드", onTap: _makeGroup),
              const SizedBox(height: columnPadding),
              _FilledButton(text: "기록 보기", onTap: _makeGroup),
              const SizedBox(height: columnPadding),
              _FilledButton(text: "설정", onTap: _makeGroup),
            ],
          ),
        ),
      ),
    );
  }
}

class _JoinGroupRow extends StatelessWidget {
  const _JoinGroupRow({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    List<String>? entries =
        context.findAncestorStateOfType<_LobbyPageState>()?.entries;
    List<int>? colorCodes =
        context.findAncestorStateOfType<_LobbyPageState>()?.colorCodes;

    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            "온라인 크루 목록",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 10),
          Container(
            height: 300,
            decoration: BoxDecoration(
              // border: Border.all(
              //   color: Color(0xFFF05A22),
              //   style: BorderStyle.solid,
              //   width: 1.0,
              // ),
              color: BicrewColors.inputBackground,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: entries?.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  color: Colors.amber[colorCodes?[index] ?? 1],
                  child: Center(child: Text('Entry ${entries?[index]}')),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                "리스트의 크루을 선택해서",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Expanded(child: SizedBox.shrink()),
              _FilledButton(
                text: "크루 참여",
                onTap: onTap,
              ),
            ],
          ),
        ],
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
