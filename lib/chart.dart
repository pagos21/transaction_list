import 'dart:developer';

import 'package:corso_02/chart_bar.dart';
import 'package:corso_02/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;
  const Chart({super.key, required this.recentTransactions});

  double get maxSpending {
    return groupTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  List<Map<String, Object>> get groupTransactionValues {
    initializeDateFormatting("it_IT");
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      // log(DateFormat.E().format(weekDay));
      // log(totalSum.toString());
      return {
        'day':
            DateFormat.E("it_IT").format(weekDay).substring(0, 1).toUpperCase(),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    log("build Chart");
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: groupTransactionValues.map((e) {
            return Flexible(
              // flex: 1,
              //Same as Explanded
              fit: FlexFit.tight,
              child: ChartBar(
                label: e['day'].toString(),
                spendingAmount: e['amount'] as double,
                spendingPctOfTotal: maxSpending == 0.0
                    ? 0.0
                    : (e['amount'] as double) / maxSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
