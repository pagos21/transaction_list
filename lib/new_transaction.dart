// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function txHandler;

  NewTransaction({super.key, required this.txHandler}) {
    log("constr new_tx");
  }

  @override
  State<NewTransaction> createState() {
    log("created state new_tx");
    return _NewTransactionState();
  }
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  _NewTransactionState() {
    log("contr new_tx SATE");
  }

  @override
  void initState() {
    //Carica data dal Server via HHTP per esempio
    log("initSate()");
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NewTransaction oldWidget) {
    log("didUpdate");
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    log("dispose()");
    super.dispose();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  void _subData() {
    final enteredTitle = _titleController.text;
    if (_amountController.text.isEmpty) {
      log("prezzo vuoto, esco=>");
      return;
    }
    final enteredAmount = double.parse(_amountController.text);
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      log("form non valida, esco=>");
      return;
    }
    widget.txHandler(
      _titleController.text,
      double.parse(_amountController.text),
      _selectedDate,
    );
    //Chiude la modale
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    log("build new_tx");
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Titolo"),
                controller: _titleController,
                onSubmitted: (_) => _subData(),
                // onChanged: (value) => titleInput = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Prezzo"),
                controller: _amountController,
                keyboardType: TextInputType.number,
                //Val è necessario al submit anche se non lo utilizziamo
                onSubmitted: (_) => _subData(),
                // keyboardType: TextInputType.numberWithOptions(decimal: true),
                // onChanged: (value) => amountInput = value,
              ),
              SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? "Nessuna data"
                            : DateFormat("dd/MM/yyyy hh:mm")
                                .format(_selectedDate!),
                      ),
                    ),
                    TextButton(
                      onPressed: _presentDatePicker,
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                      ),
                      child: Text(
                        "Seleziona Data",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _selectedDate == null ? null : _subData,
                child: const Text("Inserisci"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
