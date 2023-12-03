import 'package:flutter/material.dart';
import 'package:bicrew/app.dart';
import 'package:bicrew/colors.dart';

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

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_usernameController, restorationId);
    registerForRestoration(_passwordController, restorationId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _MainView(
          usernameController: _usernameController.value,
          passwordController: _passwordController.value,
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

// 전체적인 UI
class _MainView extends StatelessWidget {
  const _MainView({
    this.usernameController,
    this.passwordController,
  });

  final TextEditingController? usernameController;
  final TextEditingController? passwordController;

  void _login(BuildContext context) {
    // Navigator.of(context).restorablePushNamed(BicrewApp.homeRoute);
    Navigator.of(context).restorablePushNamed(BicrewApp.lobbyRoute);
  }

  void _join(BuildContext context) {
    // Navigator.of(context).restorablePushNamed(BicrewApp.homeRoute);
    Navigator.of(context).restorablePushNamed(BicrewApp.namerRoute);
  }

  @override
  Widget build(BuildContext context) {
    const double rowMaxWidth = 500;

    return Column(
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
                  usernameController: usernameController,
                  maxWidth: rowMaxWidth,
                ),
                const SizedBox(height: 12),
                _PasswordInput(
                  passwordController: passwordController,
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
    );
  }
}

class _BicrewLogo extends StatelessWidget {
  const _BicrewLogo();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 64),
      child: SizedBox(
        height: 200,
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
