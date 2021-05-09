import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './transaction.dart';
import 'Transtion__item.dart';
import 'package:intl/intl.dart';
// class TransactionList extends StatelessWidget {
//   final Function deleteTx;
// final List<Transaction> transactions;
// TransactionList(this.transactions,this.deleteTx);
//
//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery=MediaQuery.of(context);
//     return   transactions.isEmpty?
//     LayoutBuilder(builder: (ctx,constraints)
//     {
//       return
//         Column(children: <Widget>[
//           Text('No transactions added yet!',style: TextStyle(
//               fontWeight: FontWeight.bold,fontSize: 18),),
//           SizedBox(height: 20,),
//           Container(
//               height: constraints.maxHeight*0.6,
//               child: Image.asset('assets/images/waiting.png',fit: BoxFit.cover,)),
//         ],);
//     },)
//  : ListView(children:
//
//    transactions.map((tx) => TransactionItem(
//        // key: ValueKey(tx.id),
//        transactions: tx, mediaQuery: mediaQuery, deleteTx: deleteTx)).toList(),
//     );
//
//
//               //   Card(child: Row(children: <Widget>[
//   //   Container(
//   //     margin:EdgeInsets.symmetric(vertical: 10,horizontal: 15),
//   //     decoration: BoxDecoration(
//   //
//   //         border: Border.all(color: Theme.of(context).primaryColorDark)),
//   //     padding: EdgeInsets.all(10),
//   //
//   //     child: Text('₹'+ transactions[index].amount.toStringAsFixed(2),style: TextStyle(fontWeight:FontWeight.bold,color: Theme.of(context).primaryColorDark,fontSize: 20),),),
//   //   Column(
//   //
//   //     mainAxisAlignment:MainAxisAlignment.center,
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     children: <Widget>[
//   //
//   //       Text(transactions[index].title,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
//   //       Text(DateFormat.yMMMMd().format(transactions[index].date),style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,),),
//   //
//   //     ],)
//   // ],
//   // ),
//   // );
//
//
//
//
//
//
//   }
// }
class TransactionList extends StatelessWidget {
  final List<Transaction> _allTransactions;
  final Function _deleteTransaction;

  TransactionList(this._allTransactions, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    final mediaQuery=MediaQuery.of(context);
    return LayoutBuilder(builder: (ctx, constraints) {
      return _allTransactions.isEmpty
      // No Transactions
          ?  LayoutBuilder(builder: (ctx,constraints)
      {
        return
          Column(children: <Widget>[
            Text('No transactions added yet!',style: TextStyle(
                fontWeight: FontWeight.bold,fontSize: 18),),
            SizedBox(height: 20,),
            Container(
                height: constraints.maxHeight*0.6,
                child: Image.asset('assets/images/waiting.png',fit: BoxFit.cover,)),
          ],);
      },)
      // Transactions Present
          : ListView.builder(
        itemCount: _allTransactions.length,
        itemBuilder: (context, index) {
          Transaction txn = _allTransactions[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0),
            child:Card(

              elevation: 5,
              margin: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 5,
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Padding(
                    padding: EdgeInsets.all(6),
                    child: FittedBox(
                        child: Text('₹${txn.txnAmount}')),
                  ),
                ),
                title: Text(
                  txn.txnTitle,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                subtitle: Text(
                    DateFormat.yMMMMd().format(txn.txnDateTime)),
                trailing: mediaQuery.size.width > 460
                    ? FlatButton.icon(
                    onPressed: () => _deleteTransaction(txn.txnId),
                    icon: Icon(Icons.delete),
                    textColor: Colors.blue,
                    label: Text('Delete'))
                    : IconButton(
                  icon: Icon(Icons.delete),
                  color: Colors.blue,
                  onPressed: () => _deleteTransaction(txn.txnId),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

