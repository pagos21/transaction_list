// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:corso_02/chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './new_transaction.dart';
import 'package:corso_02/transaction_list.dart';
import 'package:flutter/material.dart';
import 'models/transaction.dart';

void main() {
  //Disabilita la possibilità di ruotare il dispositivo
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //Default is Roboto
        fontFamily: "Quicksand",
        textTheme: ThemeData.light().textTheme.copyWith(
              titleMedium: TextStyle(
                  fontFamily: "OpenSans",
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(
          toolbarTextStyle: ThemeData.light()
              .textTheme
              .copyWith(
                headline6: TextStyle(fontFamily: "OpenSans", fontSize: 15),
              )
              .bodyText2,
          titleTextStyle: ThemeData.light()
              .textTheme
              .copyWith(
                //headline 6 is title
                headline6: TextStyle(
                    fontFamily: "OpenSans",
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )
              .headline6,
        ),
        // colorScheme: ColorScheme(),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  //var o function section

  @override
  void initState() {
    log("main initState called");
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log("new state reached");
    log(state.toString());
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    log("dispose main called");
    super.dispose();
  }

  final Future _prefs = SharedPreferences.getInstance();

  //essendo final non puoi ridichiararla una volta assegnata ma essendo un Pointer alla memoria puoi aggiungere dati con add
  List<Transaction> _userTransaction = [
    // Transaction(
    //   id: 't1',
    //   title: "Nuove Scarpe",
    //   amount: 85.95,
    //   date: DateTime.now().subtract(Duration(days: 2)),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: "Kiwi",
    //   amount: 12.21,
    //   date: DateTime.now().subtract(Duration(days: 4)),
    // ),
    // Transaction(
    //   id: 't3',
    //   title: "Pesche",
    //   amount: 8.25,
    //   date: DateTime.now().subtract(Duration(days: 5)),
    // ),
  ];

  List<Transaction> fromStore = [];

  void _stored() async {
    final SharedPreferences prefs = await _prefs;
    final keys = prefs.getKeys();
    // List<String>? encodedMap = prefs.getStringList('tx');
    final prefsMap = Map<String, dynamic>();
    for (String key in keys) {
      prefsMap[key] = prefs.get(key);
    }
    log(keys.toString());
    log(prefsMap.values.toList().toString());
    List<dynamic> asd = jsonDecode(prefsMap.values.toList().first.toString());
    // log(asd.toString());
    // var qwe = Transaction.fromJson(asd);
    var qwe = asd.map((e) => Transaction.fromJson(e)).toList();
    setState(() {
      _userTransaction = qwe;
    });
    log(fromStore.toString());
  }

  List<Transaction> get _recentTransaction {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  Future<void> _addNewTransaction(
      String txTitle, double txAmount, DateTime date) async {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: date,
    );
    setState(() {
      _userTransaction.add(newTx);
    });
    final SharedPreferences prefs = await _prefs;
    List<String> encoded =
        _userTransaction.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(date.toString(), encoded);
    log("tutto OK");
  }

  Future<void> _deleteTx(String id) async {
    final SharedPreferences prefs = await _prefs;
    List<String> encoded =
        _userTransaction.map((e) => jsonEncode(e.toJson())).toList();
    log("Removing " + id);
    await prefs.remove(id);
    setState(() {
      _userTransaction.removeWhere((element) => element.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(txHandler: _addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQ, AppBar appBar, Widget txList) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Show Chart"),
          Switch(
            value: _showChart,
            onChanged: (value) {
              setState(() {
                _showChart = value;
              });
            },
          )
        ],
      ),
      _showChart
          ? SizedBox(
              height: (mediaQ.size.height -
                      appBar.preferredSize.height -
                      mediaQ.padding.top) *
                  .7,
              child: Chart(
                recentTransactions: _recentTransaction,
              ),
            )
          : txList
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQ, AppBar appBar, Widget txList) {
    return [
      SizedBox(
        height: (mediaQ.size.height -
                appBar.preferredSize.height -
                mediaQ.padding.top) *
            .3,
        child: Chart(
          recentTransactions: _recentTransaction,
        ),
      ),
      txList
    ];
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    log("build Main");
    final mediaQ = MediaQuery.of(context);
    //ricalcolato ogno volta che giri il dispositivo quindi può essere final
    final isLandscape = mediaQ.orientation == Orientation.landscape;
    //appBar assegnata ad una viariabile per poter avere accesso (ovunque) alle informazioni inerenta ad esempio alla sua height
    var appBar = AppBar(
      title: const Text("Elenco Spese"),
      actions: [
        IconButton(
          onPressed: () => _stored(),
          icon: Icon(Icons.refresh),
        ),
      ],
    );
    final txList = SizedBox(
      height: (mediaQ.size.height -
              appBar.preferredSize.height -
              mediaQ.padding.top) *
          .7,
      child:
          TransactionList(transactions: _userTransaction, deleteTx: _deleteTx),
    );

    return Scaffold(
      appBar: appBar,
      //SafeAre rispetta le areee del device con non posso no essere utilizzate come ad esempio nei dispositivi iOS
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isLandscape)
                ..._buildLandscapeContent(mediaQ, appBar, txList),
              if (!isLandscape)
                ..._buildPortraitContent(mediaQ, appBar, txList),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            ),
    );
  }
}
