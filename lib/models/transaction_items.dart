import 'dart:math';

import 'package:corso_02/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItems extends StatefulWidget {
  const TransactionItems({
    Key? key,
    required this.transaction,
    required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;

  @override
  State<TransactionItems> createState() => _TransactionItemsState();
}

class _TransactionItemsState extends State<TransactionItems> {
  Color? _bgColor;
  @override
  void initState() {
    const available = [Colors.red, Colors.black, Colors.blue, Colors.orange];
    _bgColor = available[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 50,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "${widget.transaction.amount.toStringAsFixed(2)}€",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          DateFormat("dd/MM/yyyy hh:mm").format(widget.transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 450
            ? TextButton.icon(
                onPressed: (() => widget.deleteTx(widget.transaction.id)),
                icon: const Icon(Icons.delete),
                label: const Text("Cancella"),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                        Theme.of(context).errorColor)),
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => widget.deleteTx(widget.transaction.id),
              ),
      ),
    );
  }
}
