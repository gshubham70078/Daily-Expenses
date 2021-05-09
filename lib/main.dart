import 'package:daliytrack/transaction.dart';
import 'package:daliytrack/transaction_list.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'database_helper.dart';
import 'new_transaction.dart';
import './chart.dart';

void main() {
  //Lock rotated mode
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.green,accentColor: Colors.blue,),

    home: MyHomePage(),
  ));
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Transaction> _userTransactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    DateTime lastDayOfPrevWeek = DateTime.now().subtract(Duration(days: 6));
    lastDayOfPrevWeek = DateTime(
        lastDayOfPrevWeek.year, lastDayOfPrevWeek.month, lastDayOfPrevWeek.day);
    return _userTransactions.where((element) {
      return element.txnDateTime.isAfter(
        lastDayOfPrevWeek,
      );
    }).toList();
  }

  _MyHomePageState() {
    _updateUserTransactionsList();
  }

  void _showChartHandler(bool show) {
    setState(() {
      _showChart = show;
    });
  }
  void _updateUserTransactionsList() {
    Future<List<Transaction>> res =
    DatabaseHelper.instance.getAllTransactions();

    res.then((txnList) {
      setState(() {
        _userTransactions = txnList;
      });
    });
  }



  Future<void> _addNewTransaction(
      String title, double amount, DateTime chosenDate) async {
    final newTxn = Transaction(
      DateTime.now().millisecondsSinceEpoch.toString(),
      title,
      amount,
      chosenDate,
    );
    int res = await DatabaseHelper.instance.insert(newTxn);

    if (res != 0) {
      _updateUserTransactionsList();
    }
  }

  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(context: ctx, builder: (_){
      return  GestureDetector(
        onTap: (){},
        child: NewTransaction(_addNewTransaction),behavior: HitTestBehavior.opaque,);

    });
  }

  Future<void> _deleteTransaction(String id) async {
    int res =
    await DatabaseHelper.instance.deleteTransactionById(int.tryParse(id));
    if (res != 0) {
      _updateUserTransactionsList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppBar myAppBar = AppBar(
      title: Text(
        'Personal Expenses',
        style: TextStyle(
          fontFamily: "Quicksand",
          fontWeight: FontWeight.w400,
          fontSize: 20.0,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
          tooltip: "Add New Transaction",
        ),
      ],
    );
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    final bool isLandscape =
        mediaQueryData.orientation == Orientation.landscape;

    final double availableHeight = mediaQueryData.size.height -
        myAppBar.preferredSize.height -
        mediaQueryData.padding.top -
        mediaQueryData.padding.bottom;

    final double availableWidth = mediaQueryData.size.width -
        mediaQueryData.padding.left -
        mediaQueryData.padding.right;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: myAppBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Show Chart",
                    style: TextStyle(
                      fontFamily: "Rubik",
                      fontSize: 16.0,
                      color: Colors.grey[500],
                    ),
                  ),
                  Switch.adaptive(
                    activeColor: Colors.amber[700],
                    value: _showChart,
                    onChanged: (value) => _showChartHandler(value),
                  ),
                ],
              ),
            if (isLandscape)
              _showChart
                  ? myChartContainer(
                  height: availableHeight * 0.8,
                  width: 0.6 * availableWidth)
                  : myTransactionListContainer(
                  height: availableHeight * 0.8,
                  width: 0.6 * availableWidth),
            if (!isLandscape)
              myChartContainer(
                  height: availableHeight * 0.3, width: availableWidth),
            if (!isLandscape)
              myTransactionListContainer(
                  height: availableHeight * 0.7, width: availableWidth),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>_startAddNewTransaction(context),
      ),


    );
  }

  Widget myChartContainer({double height, double width}) {
    return Container(
      height: height,
      width: width,
      child: Chart(_recentTransactions),
    );
  }

  Widget myTransactionListContainer({double height, double width}) {
    return Container(
      height: height,
      width: width,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );
  }
}
