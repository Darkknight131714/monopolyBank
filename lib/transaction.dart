import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionHistory extends StatelessWidget {
  List<Widget> transaction;
  TransactionHistory({required this.transaction});
  @override
  Widget build(BuildContext context) {
    transaction = transaction.reversed.toList();
    return Scaffold(
        appBar: AppBar(title: Text("Transaction History"),),
        body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: transaction.length,
          itemBuilder: (BuildContext context, int index){
            return ListTile(
              title: Center(child: transaction[index]),
              subtitle: Center(child: Text("______________________________________")),
              tileColor: Colors.grey[800],
            );
          },
        ),
    );
  }
}
