// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;

  const ChartBar(
      {super.key,
      required this.label,
      required this.spendingAmount,
      required this.spendingPctOfTotal});

  @override
  Widget build(BuildContext context) {
    log("build Char_bar");
    return LayoutBuilder(
      builder: (ctx, constrains) {
        return Column(
          children: [
            SizedBox(
              height: constrains.maxHeight * .15,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "${spendingAmount.toStringAsFixed(0)}€",
                ),
              ),
            ),
            SizedBox(
              height: constrains.maxHeight * .05,
            ),
            SizedBox(
              height: constrains.maxHeight * .6,
              width: 10,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: spendingPctOfTotal,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: constrains.maxHeight * .05,
            ),
            SizedBox(
              height: constrains.maxHeight * .15,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(label),
              ),
            ),
          ],
        );
      },
    );
  }
}
