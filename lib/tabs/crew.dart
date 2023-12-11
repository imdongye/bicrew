// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'package:bicrew/charts/pie_chart.dart';
import 'package:bicrew/data.dart';
import 'package:bicrew/finance.dart';
import 'package:bicrew/tabs/sidebar.dart';
import 'package:bicrew/colors.dart';

class CrewView extends StatefulWidget {
  const CrewView({super.key});

  @override
  State<CrewView> createState() => _CrewViewState();
}

class MemberContainer extends StatelessWidget {
  final String name;
  final String message;

  const MemberContainer({
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
      child: Row(
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
          SizedBox(width: 4.0),
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

class _CrewViewState extends State<CrewView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '이름',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 30.0),
                    Text(
                      '상태 메시지',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('인원수: 3명'),
                  ],
                ),
              ],
            ),
          ),
          MemberContainer(
            name: '크루원 1',
            message: '기본 상태 메시지',
          ),
          MemberContainer(
            name: '크루원 2',
            message: '기본 상태 메시지',
          ),
          MemberContainer(
            name: '크루원 2',
            message: '기본 상태 메시지',
          ),
        ],
      ),
    );
  }
}
