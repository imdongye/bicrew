import 'package:flutter/material.dart';
import 'package:bicrew/app.dart';
import 'package:bicrew/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

// 로그인 유지 저장 관련
class _LoginPageState extends State<LoginPage> with RestorationMixin {
  final RestorableTextEditingController _usernameController =
      RestorableTextEditingController();
  final RestorableTextEditingController _passwordController =
      RestorableTextEditingController();

  @override
  String get restorationId => 'login_page';
//
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_usernameController, restorationId);
    registerForRestoration(_passwordController, restorationId);
  }

  void _statusDialog(String title, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: BicrewColors.primaryBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        title: Text(title),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Text(text);
          },
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).restorablePushNamed(BicrewApp.lobbyRoute);
            },
            child: const Text('강제이동'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _login(BuildContext context) async {
    String nicknameStr = _usernameController.value.text;
    String passwordStr = _passwordController.value.text;
    final url = Uri.parse(
        'http://ec2-52-79-236-34.ap-northeast-2.compute.amazonaws.com:8080/api/v1/users');

    // 요청
    http.Response response = await http.post(
      url,
      headers: {"content-type": "application/json"},
      body: jsonEncode({
        "nickname": nicknameStr,
        "password": passwordStr,
      }),
    );

    if (response.statusCode == 200) {
      print("로그인 성공");
      String? accessToken = response.headers["Authorization"]?.split(" ")[1];
      Navigator.of(context).restorablePushNamed(BicrewApp.lobbyRoute);
    } else {
      _statusDialog("로그인 실패", "아이디 또는 비밀번호를 다시 입력해 주세요.");
      print("로그인 실패");
    }
  }

  void _join(BuildContext context) async {
    String nicknameStr = _usernameController.value.text;
    String passwordStr = _passwordController.value.text;
    final url = Uri.parse(
        'http://ec2-52-79-236-34.ap-northeast-2.compute.amazonaws.com:8080/api/v1/users/login');

    // 요청
    http.Response response = await http.post(
      url,
      headers: {"content-type": "application/json"},
      body: jsonEncode({
        "nickname": nicknameStr,
        "password": passwordStr,
      }),
    );

    if (response.statusCode == 200) {
      print("회원가입 성공");
      _statusDialog("회원가입 성공", "로그인버튼으로 접속해주세요${response.statusCode}");
    } else {
      _statusDialog(
          "회원가입 실패", "아이디 또는 비밀번호를 다시 입력해 주세요.${response.statusCode}");
      print("회원가입 실패");
    }
  }

  @override
  Widget build(BuildContext context) {
    const double rowMaxWidth = 500;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ListView(
                  restorationId: 'login_list_view',
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    const _BicrewLogo(),
                    _UsernameInput(
                      usernameController: _usernameController.value,
                      maxWidth: rowMaxWidth,
                    ),
                    const SizedBox(height: 12),
                    _PasswordInput(
                      passwordController: _passwordController.value,
                      maxWidth: rowMaxWidth,
                    ),
                    const SizedBox(height: 25),
                    _LoginRow(
                      onTap: () {
                        _login(context);
                      },
                      maxWidth: rowMaxWidth,
                    ),
                    const SizedBox(height: 25),
                    JoinRow(
                      onTap: () {
                        _join(context);
                      },
                      maxWidth: rowMaxWidth,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class _BicrewLogo extends StatelessWidget {
  const _BicrewLogo();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 64),
      child: SizedBox(
        height: 230,
        // 접근성에서 제외시키는 위젯
        child: ExcludeSemantics(
          // Todo: fade in
          child: Column(
            children: [
              Text(
                "🚵‍♂️",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 70.0,
                ),
              ),
              Text(
                "바이크루",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50.0,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "동료간의 통신이 가능한 속도계 앱",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  const _UsernameInput({
    this.maxWidth,
    this.usernameController,
  });

  final double? maxWidth;
  final TextEditingController? usernameController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: TextField(
          autofillHints: const [AutofillHints.username],
          textInputAction: TextInputAction.next,
          controller: usernameController,
          decoration: const InputDecoration(
            labelText: "사용자 이름",
          ),
        ),
      ),
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({
    this.maxWidth,
    this.passwordController,
  });

  final double? maxWidth;
  final TextEditingController? passwordController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: TextField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: "비밀번호",
          ),
          obscureText: true,
        ),
      ),
    );
  }
}

class _LoginRow extends StatelessWidget {
  const _LoginRow({
    required this.onTap,
    this.maxWidth,
  });

  final double? maxWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: Row(
          children: [
            const Icon(Icons.check_circle_outline,
                color: BicrewColors.buttonColor),
            const SizedBox(width: 12),
            const Text("로그인 정보 저장"),
            const Expanded(child: SizedBox.shrink()),
            _FilledButton(
              text: "로그인",
              onTap: onTap,
              iconData: Icons.lock,
            ),
          ],
        ),
      ),
    );
  }
}

class JoinRow extends StatelessWidget {
  const JoinRow({
    required this.onTap,
    this.maxWidth,
  });

  final double? maxWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: Row(
          children: [
            Text(
              "계정이 없다면?",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Expanded(child: SizedBox.shrink()),
            _BorderButton(
              text: "회원 가입",
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _BorderButton extends StatelessWidget {
  const _BorderButton({required this.text, required this.onTap, this.iconData});

  final String text;
  final VoidCallback onTap;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: BicrewColors.buttonColor),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
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

class _FilledButton extends StatelessWidget {
  const _FilledButton({required this.text, required this.onTap, this.iconData});

  final String text;
  final VoidCallback onTap;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
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
