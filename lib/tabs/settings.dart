// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:bicrew/layout/adaptive.dart';
import 'package:bicrew/colors.dart';
import 'package:bicrew/data.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
      child: Container(
        padding: EdgeInsets.only(top: isDisplayDesktop(context) ? 24 : 0),
        child: ListView(
          restorationId: 'settings_list_view',
          shrinkWrap: true,
          children: const [
            _SettingLobbyItem(),
            Divider(color: BicrewColors.dividerColor, height: 1),
            _SettingLogoutItem(),
            Divider(color: BicrewColors.dividerColor, height: 1),
          ],
        ),
      ),
    );
  }
}

class _SettingLobbyItem extends StatelessWidget {
  const _SettingLobbyItem();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: EdgeInsets.zero,
      ),
      onPressed: () {
        Navigator.of(context).restorablePushNamed('/bicrew/login');
      },
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
        child: const Text("로비로 이동"),
      ),
    );
  }
}

class _SettingLogoutItem extends StatelessWidget {
  const _SettingLogoutItem();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: EdgeInsets.zero,
      ),
      onPressed: () {
        Navigator.of(context).restorablePushNamed('/bicrew/login');
      },
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
        child: const Text("로그아웃"),
      ),
    );
  }
}
