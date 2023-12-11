// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:bicrew/layout/adaptive.dart';
import 'package:bicrew/layout/text_scale.dart';
import 'package:bicrew/colors.dart';
import 'package:bicrew/data.dart';
import 'package:bicrew/finance.dart';

/// A page that shows a status overview.
class OverviewView extends StatefulWidget {
  const OverviewView({super.key});

  @override
  State<OverviewView> createState() => _OverviewViewState();
}

class MessageContainer extends StatelessWidget {
  final String name;
  final String message;

  const MessageContainer({
    Key? key,
    required this.name,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            message,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}


class _OverviewViewState extends State<OverviewView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MessageContainer(
            name: '크루원 2',
            message: '천천히 가세요.',
          ),
          MessageContainer(
            name: '크루원 3',
            message: '알겠습니다.',
          ),
          MessageContainer(
            name: '크루원 3',
            message: '빨리 오세요.',
          ),
          ElevatedButton(
            onPressed: () {
              _showMessageSelectionDialog(context);
            },
            child: Text('Add Message'),
          ),
        ],
      ),
    );
  }

  void _showMessageSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a message'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  onTap: () {
                    // 여기에 선택한 메시지에 대한 로직을 추가하세요.
                    Navigator.pop(context, 'Message 1');
                  },
                  child: Text('천천히 가세요.'),
                ),
                GestureDetector(
                  onTap: () {
                    // 여기에 선택한 메시지에 대한 로직을 추가하세요.
                    Navigator.pop(context, 'Message 2');
                  },
                  child: Text('빨리 오세요.'),
                ),
                GestureDetector(
                  onTap: () {
                    // 여기에 선택한 메시지에 대한 로직을 추가하세요.
                    Navigator.pop(context, 'Message 3');
                  },
                  child: Text('멈춰주세요.'),
                ),
                GestureDetector(
                  onTap: () {
                    // 여기에 선택한 메시지에 대한 로직을 추가하세요.
                    Navigator.pop(context, 'Message 2');
                  },
                  child: Text('알겠습니다.'),
                ),
              ],
            ),
          ),
        );
      },
    ).then((selectedMessage) {
      if (selectedMessage != null) {
        // 선택한 메시지를 이용하여 무언가를 수행하세요.
        print('Selected message: $selectedMessage');
      }
    });
  }
}