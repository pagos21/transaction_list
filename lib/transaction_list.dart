// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:corso_02/models/transaction.dart';
import 'package:flutter/material.dart';

import 'models/transaction_items.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;
  const TransactionList(
      {super.key, required this.transactions, required this.deleteTx});

  @override
  Widget build(BuildContext context) {
    log("build tx_list");
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constrains) {
            return Column(
              children: [
                Text(
                  "Niente da mostrare",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(
                  height: 12,
                ),
                SizedBox(
                  height: isLandscape ? constrains.maxHeight * .8 : null,
                  width: !isLandscape ? constrains.maxWidth * .7 : null,
                  // padding: EdgeInsets.all(25),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      "assets\\images\\comic-guy.webp",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            );
          })
        : ListView(
            children: transactions
                .map(
                  (e) => TransactionItems(
                    transaction: e,
                    deleteTx: deleteTx,
                    key: ValueKey(e.id),
                  ),
                )
                .toList(),
          );
    //Listview builer crea i child widget man mano che ne ha bisogno (quando possono essere renderizzati)
    //al momento listview builder ha un bug che impedisce il coreretto funzionamento del key Value quindi bisogna usare la ListView()
    // : ListView.builder(
    //     itemCount: transactions.length,
    //     itemBuilder: (ctx, index) {
    //       return TransactionItems(
    //         transaction: transactions[index],
    //         deleteTx: deleteTx,
    //         //Unique a ogni rebuild genera una nuovo unique key che va a cambiare il colore del circle avatar
    //         //non trovando il widget con quel key eliminato, Flutter rigenera la lista con nuovi random colors
    //         // key: UniqueKey(),
    //         key: ValueKey(transactions[index].id),
    //       );

    // return Card(
    //   child: Row(
    //     children: [
    //       Container(
    //         padding: EdgeInsets.all(10),
    //         decoration: BoxDecoration(
    //           border: Border.all(
    //             color: Theme.of(context).primaryColor,
    //             width: 2,
    //           ),
    //         ),
    //         margin: EdgeInsets.symmetric(
    //           vertical: 10,
    //           horizontal: 15,
    //         ),
    //         child: Text(
    //           "${transactions[index].amount.toStringAsFixed(2)}€",
    //           style: TextStyle(
    //             fontWeight: FontWeight.bold,
    //             fontSize: 20,
    //             color: Theme.of(context).primaryColor,
    //           ),
    //         ),
    //       ),
    //       //Column per i dati della row
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Text(
    //             transactions[index].title,
    //             style: Theme.of(context).textTheme.titleMedium,
    //           ),
    //           Text(
    //             DateFormat("dd/MM/yyyy hh:mm")
    //                 .format(transactions[index].date),
    //             style: TextStyle(
    //               fontSize: 12,
    //               color: Colors.grey,
    //             ),
    //           ),
    //         ],
    //       )
    //     ],
    //   ),
    // );
    // },
    // children: transactions.map((tx) {

    // }).toList(),
    // );
  }
}
