// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bicrew/layout/letter_spacing.dart';
import 'package:bicrew/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bicrew/login.dart';
import 'package:bicrew/lobby.dart';
import 'package:bicrew/home.dart';
import 'package:bicrew/namer_app.dart';

class BicrewApp extends StatelessWidget {
  const BicrewApp({super.key});

  static const String loginRoute = '/bicrew/login';
  static const String lobbyRoute = '/bicrew/lobby';
  static const String homeRoute = '/bicrew';
  static const String namerRoute = '/test/nammer_app'; // 테스트용 앱

  // 화면전환 애니메이션
  final sharedZAxisTransitionBuilder = const SharedAxisPageTransitionsBuilder(
    fillColor: BicrewColors.primaryBackground,
    transitionType: SharedAxisTransitionType.scaled,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 앱의 상태 저장
      restorationScopeId: 'bicrew_app',
      title: 'Bicrew',
      debugShowCheckedModeBanner: false,
      theme: _buildBicrewTheme().copyWith(
        //platform: GalleryOptions.of(context).platform,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            for (var type in TargetPlatform.values)
              type: sharedZAxisTransitionBuilder,
          },
        ),
      ),
      initialRoute: loginRoute,
      routes: <String, WidgetBuilder>{
        loginRoute: (context) => const LoginPage(),
        lobbyRoute: (context) => const LobbyPage(),
        homeRoute: (context) => const HomePage(),
        namerRoute: (context) => const MyNamerApp(),
      },
    );
  }

  ThemeData _buildBicrewTheme() {
    final base = ThemeData.dark();
    return ThemeData(
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: BicrewColors.primaryBackground,
        elevation: 0,
      ),
      scaffoldBackgroundColor: BicrewColors.primaryBackground,
      focusColor: BicrewColors.focusColor,
      textTheme: _buildBicrewTextTheme(base.textTheme),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(
          color: BicrewColors.gray,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: BicrewColors.inputBackground,
        focusedBorder: InputBorder.none,
      ),
      visualDensity: VisualDensity.standard,
      colorScheme: base.colorScheme.copyWith(
        primary: BicrewColors.primaryBackground,
      ),
    );
  }

  TextTheme _buildBicrewTextTheme(TextTheme base) {
    return base
        .copyWith(
          bodyMedium: GoogleFonts.robotoCondensed(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: letterSpacingOrNone(0.5),
          ),
          bodyLarge: GoogleFonts.eczar(
            fontSize: 40,
            fontWeight: FontWeight.w400,
            letterSpacing: letterSpacingOrNone(1.4),
          ),
          labelLarge: GoogleFonts.robotoCondensed(
            fontWeight: FontWeight.w700,
            letterSpacing: letterSpacingOrNone(2.8),
          ),
          headlineSmall: GoogleFonts.eczar(
            fontSize: 40,
            fontWeight: FontWeight.w600,
            letterSpacing: letterSpacingOrNone(1.4),
          ),
        )
        .apply(
          displayColor: Colors.white,
          bodyColor: Colors.white,
        );
  }
}
