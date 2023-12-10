import 'package:flutter/material.dart';
import 'package:bicrew/app.dart';
import 'package:bicrew/colors.dart';
import 'package:numberpicker/numberpicker.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({super.key});

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  final TextEditingController crewNameCtrl = TextEditingController();
  final TextEditingController crewPwCtrl = TextEditingController();
  var nrCurMembers = 5;
  var nrMembers = 5;
  var maxDistKM = 2;

  void _currentCrewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: BicrewColors.primaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: Text('현재 크루: ${crewNameCtrl.text}'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: 68,
              width: 300,
              child: Column(
                children: [
                  const Text("모든 인원 참가까지 대기 중.."),
                  const SizedBox(height: 20),
                  Text("$nrCurMembers/$nrMembers"),
                ],
              ),
            );
          },
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('나가기'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .restorablePushNamed(BicrewApp.sppedometerRoute);
            },
            child: const Text('강제 속도계 모드'),
          ),
        ],
      ),
    );
  }

  void _joinCrewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: BicrewColors.primaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: const Text('크루 참여'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: 160,
              width: 300,
              child: Column(
                children: [
                  _CrewNameInput(crewNameCtrl: crewNameCtrl),
                  const SizedBox(height: 17),
                  _CrewPasswordInput(crewPwCtrl: crewPwCtrl),
                ],
              ),
            );
          },
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _currentCrewDialog();
            },
            child: const Text('참여'),
          ),
        ],
      ),
    );
  }

  final int minNrMembers = 2;
  final int maxNrMembers = 10;

  void _makeCrewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: BicrewColors.primaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: const Text('크루 만들기'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: 500,
              width: 300,
              child: Column(
                children: [
                  _CrewNameInput(crewNameCtrl: crewNameCtrl),
                  const SizedBox(height: 17),
                  _CrewPasswordInput(crewPwCtrl: crewPwCtrl),
                  NumberPicker(
                    value: nrCurMembers,
                    minValue: minNrMembers,
                    maxValue: maxNrMembers,
                    step: 1,
                    axis: Axis.horizontal,
                    itemHeight: 100,
                    onChanged: (value) => setState(() => nrCurMembers = value),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => setState(() {
                          final newValue = nrCurMembers - 1;
                          nrCurMembers =
                              newValue.clamp(minNrMembers, maxNrMembers);
                        }),
                      ),
                      Text('인원 수(방장 포함) : $nrCurMembers'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() {
                          final newValue = nrCurMembers + 1;
                          nrCurMembers =
                              newValue.clamp(minNrMembers, maxNrMembers);
                        }),
                      ),
                    ],
                  ),
                  NumberPicker(
                    value: maxDistKM,
                    minValue: 1,
                    maxValue: 6,
                    step: 1,
                    axis: Axis.horizontal,
                    itemHeight: 100,
                    onChanged: (value) => setState(() => maxDistKM = value),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => setState(() {
                          final newValue = maxDistKM - 1;
                          maxDistKM = newValue.clamp(0, 10);
                        }),
                      ),
                      Text('알림 거리 $maxDistKM KM'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() {
                          final newValue = maxDistKM + 1;
                          maxDistKM = newValue.clamp(0, 10);
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _currentCrewDialog();
            },
            child: const Text('만들기'),
          ),
        ],
      ),
    );
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
        title: const Text('🚵 로비 페이지'),
        backgroundColor: const Color(0xFF26282F),
      ),
      body: Center(
        child: Container(
          width: rowMaxWidth,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const SizedBox(height: 10),
              // _JoinGroupRow(onTap: _joinCrewDialog),
              // const SizedBox(height: 8),
              // const Divider(color: BicrewColors.white60),
              const SizedBox(height: columnPadding),
              _FilledButton(
                  text: "크루 참여", onTap: _joinCrewDialog, icon: Icons.group),
              const SizedBox(height: columnPadding),
              _FilledButton(
                  text: "크루 만들기",
                  onTap: _makeCrewDialog,
                  icon: Icons.group_add),
              const SizedBox(height: columnPadding),
              _FilledButton(
                  text: "속도계 모드", onTap: _goSpeedometer, icon: Icons.speed),
              const SizedBox(height: columnPadding),
              _FilledButton(text: "기록 보기", onTap: _goHistory, icon: Icons.book),
              const SizedBox(height: columnPadding),
              _FilledButton(
                  text: "설정", onTap: _goSettings, icon: Icons.settings),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

// class _JoinGroupRow extends StatelessWidget {
//   const _JoinGroupRow({
//     required this.onTap,
//   });

//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     List<String>? entries =
//         context.findAncestorStateOfType<_LobbyPageState>()?.entries;
//     List<int>? colorCodes =
//         context.findAncestorStateOfType<_LobbyPageState>()?.colorCodes;

//     return Align(
//       alignment: Alignment.center,
//       child: Column(
//         children: [
//           Text(
//             "온라인 크루 목록",
//             style: Theme.of(context).textTheme.titleMedium,
//           ),
//           const SizedBox(height: 10),
//           Container(
//             height: 300,
//             decoration: BoxDecoration(
//               // border: Border.all(
//               //   color: Color(0xFFF05A22),
//               //   style: BorderStyle.solid,
//               //   width: 1.0,
//               // ),
//               color: BicrewColors.inputBackground,
//               borderRadius: BorderRadius.circular(10.0),
//             ),
//             child: ListView.builder(
//               padding: const EdgeInsets.all(8),
//               itemCount: entries?.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return Container(
//                   height: 50,
//                   color: Colors.amber[colorCodes?[index] ?? 1],
//                   child: Center(child: Text('Entry ${entries?[index]}')),
//                 );
//               },
//             ),
//           ),
//           Container(
//             decoration: const BoxDecoration(
//               borderRadius: BorderRadius.all(
//                 Radius.circular(20.0),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color.fromARGB(64, 0, 0, 0),
//                   blurRadius: 0.0,
//                   offset: Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: TextButton(
//               style: TextButton.styleFrom(
//                 minimumSize: const Size.fromHeight(30),
//                 textStyle: const TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 backgroundColor: BicrewColors.buttonColor,
//                 foregroundColor: Colors.black,
//                 padding: const EdgeInsets.all(0.0),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               onPressed: onTap,
//               child: const Icon(Icons.replay, size: 20),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               Text(
//                 "리스트의 크루을 선택하고",
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//               const Expanded(child: SizedBox.shrink()),
//               _FilledButton(
//                 text: "크루 참여",
//                 onTap: onTap,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

class _FilledButton extends StatelessWidget {
  const _FilledButton({
    required this.text,
    required this.onTap,
    this.minSize = 200,
    this.icon,
  });

  final String text;
  final VoidCallback onTap;
  final IconData? icon;
  final double minSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: minSize,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(64, 0, 0, 0),
            blurRadius: 0.0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size(minSize, 0),
          textStyle: const TextStyle(
            fontSize: 20,
            // fontWeight: FontWeight.bold,
          ),
          foregroundColor: Colors.black,
          backgroundColor: BicrewColors.buttonColor,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: (icon != null)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon),
                  const SizedBox(width: 6),
                  Text(text),
                ],
              )
            : Text(text),
      ),
    );
  }
}

class _CrewNameInput extends StatelessWidget {
  const _CrewNameInput({
    this.crewNameCtrl,
  });

  final TextEditingController? crewNameCtrl;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextField(
        autofillHints: const [AutofillHints.username],
        textInputAction: TextInputAction.next,
        controller: crewNameCtrl,
        decoration: const InputDecoration(
          labelText: "크루 이름(ID)",
        ),
      ),
    );
  }
}

class _CrewPasswordInput extends StatelessWidget {
  const _CrewPasswordInput({
    this.crewPwCtrl,
  });

  final TextEditingController? crewPwCtrl;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextField(
        autofillHints: const [AutofillHints.username],
        textInputAction: TextInputAction.next,
        controller: crewPwCtrl,
        decoration: const InputDecoration(
          labelText: "크루 PW",
        ),
      ),
    );
  }
}
