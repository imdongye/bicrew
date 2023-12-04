import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:bicrew/charts/pie_chart.dart';
import 'package:bicrew/data.dart';
import 'package:bicrew/finance.dart';
import 'package:bicrew/tabs/sidebar.dart';
import 'package:bicrew/colors.dart';

class SpeedometerView extends StatefulWidget {
  const SpeedometerView({super.key});

  final double kiloPerHour = 20.0;

  @override
  State<SpeedometerView> createState() => SpeedometerViewState();
}

class SpeedometerViewState extends State<SpeedometerView> {
  @override
  Widget build(BuildContext context) {
    final items = DummyDataService.getAccountDataList(context);

    const maxWidth = 400.0;
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              // We decrease the max height to ensure the [RallyPieChart] does
              // not take up the full height when it is smaller than
              // [kPieChartMaxSize].
              maxHeight: math.min(
                constraints.biggest.shortestSide * 0.9,
                maxWidth,
              ),
            ),
            child: RallyPieChart(
              heroLabel: "heroLabel",
              heroAmount: widget.kiloPerHour,
              wholeAmount: widget.kiloPerHour,
              segments: buildSegmentsFromAccountItems(items),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 1,
            constraints: BoxConstraints(maxWidth: maxWidth),
            color: BicrewColors.inputBackground,
          ),
          Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            color: BicrewColors.cardBackground,
            child: Column(
              children: buildAccountDataListViews(items, context),
            ),
          ),
        ],
      );
    });
  }
}
