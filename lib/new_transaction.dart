import 'package:daliytrack/transaction.dart';
import 'package:daliytrack/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'new_transaction.dart';
class NewTransaction extends StatefulWidget {
  final Function ttuser;

  NewTransaction(this.ttuser);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController=TextEditingController();

  final _amountController=TextEditingController();
  DateTime _selectDate;
  void _presentDatePicker(){
    showDatePicker(context: context, initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime.now()).then((pickedDate){
      if(pickedDate == null){
        return;
      }
      setState(() {
        _selectDate=pickedDate;
      });

    });

  }

  void _submitData(){
    if(_amountController.text.isEmpty){
      return;
    }
    final enterTitle=_titleController.text;
    final enterAmount=double.parse(_amountController.text);
    if(enterTitle.isEmpty || enterAmount <= 0 || _selectDate == null){
      return;
    }
    widget.ttuser(enterTitle,enterAmount,_selectDate);
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    return     SingleChildScrollView(
      child: Card(
        elevation: 3,
        child: Container(
          padding: EdgeInsets.only(top: 10,left: 10,right: 10,bottom: MediaQuery.of(context).viewInsets.bottom+10,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children:<Widget>[
              TextField(cursorColor:Colors.red,decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,onSubmitted: (_)=>_submitData()),
              TextField(cursorColor:Colors.red,decoration: InputDecoration(labelText: 'Amount'),
                // onChanged: (val)=> amountinput =val,
                controller: _amountController,keyboardType: TextInputType.number,
                onSubmitted: (_)=>_submitData(),

              ),
              Container(
                height: 70,
                child: Row(
                  children:<Widget> [
                    Expanded(child: Text(_selectDate== null?'No Date chosen!':'Picked Date : ${DateFormat.yMMMMd().format(_selectDate)}',style: TextStyle(fontWeight: FontWeight.bold),)),

                    FlatButton(onPressed: _presentDatePicker


                    , child: Text('Choose Date',style: TextStyle(fontWeight: FontWeight.bold)),textColor: Colors.blue,)
                  ],
                ),
              ),
              RaisedButton(
                  color:Colors.indigo,
                  onPressed: _submitData, child: Text('Add Transcation',style: TextStyle(color: Colors.white),))
            ],
          ),
        ),
      ),
    );
  }
}
