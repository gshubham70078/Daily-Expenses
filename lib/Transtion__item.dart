import 'package:flutter/material.dart';
import 'transaction.dart';
import 'package:intl/intl.dart';
class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.transactions,
    @required this.mediaQuery,
    @required this.deleteTx,
  }) : super(key: key);

  final Transaction transactions;
  final MediaQueryData mediaQuery;
  final Function deleteTx;

  @override
  Widget build(BuildContext context) {
    return Card(

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
                child: Text('₹${transactions.txnAmount}')),
          ),
        ),
        title: Text(
          transactions.txnTitle,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.start,
        ),
        subtitle: Text(
            DateFormat.yMMMMd().format(transactions.txnDateTime)),
        trailing: mediaQuery.size.width > 460
            ? FlatButton.icon(
            onPressed: () => deleteTx(transactions.txnId),
            icon: Icon(Icons.delete),
            textColor: Colors.blue,
            label: Text('Delete'))
            : IconButton(
          icon: Icon(Icons.delete),
          color: Colors.blue,
          onPressed: () => deleteTx(transactions.txnId),
        ),
      ),
    );
  }
}
