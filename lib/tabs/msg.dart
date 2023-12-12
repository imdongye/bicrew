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

class _FilledButton extends StatelessWidget {
  const _FilledButton({
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: minSize,
      height: 100,
      width: double.infinity,
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
          // minimumSize: Size(minSize, 0),
          textStyle: const TextStyle(
            fontSize: 20,
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
        child: Text(text),
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
          // ElevatedButton(
          //   onPressed: () {
          //     _showMessageSelectionDialog(context);
          //   },
          //   child: Text('Add Message'),
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              _FilledButton(onTap: () {}, text: "빨리오세요."),
              SizedBox(height: 10),
              _FilledButton(onTap: () {}, text: "천천히 가세요."),
              SizedBox(height: 10),
              _FilledButton(onTap: () {}, text: "여기서 쉬고 갑시다."),
              SizedBox(height: 10),
            ],
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
