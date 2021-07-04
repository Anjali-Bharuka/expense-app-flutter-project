import 'package:expenseapp/widgets/adaptive_flat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class newtransaction extends StatefulWidget {
  final Function addtx;

  newtransaction(this.addtx);

  @override
  _newtransactionState createState() => _newtransactionState();
}

class _newtransactionState extends State<newtransaction> {
  final titlecontroller = TextEditingController();

  final amountcontroller = TextEditingController();
  DateTime _selecteddate;
  void _submitData() {
    if (amountcontroller.text == null) {
      return;
    }
    final titlenew = titlecontroller.text;
    final amountnew = amountcontroller.text;
    if (titlenew.isEmpty ||
        double.parse(amountnew) <= 0 ||
        _selecteddate == null) {
      return;
    }
    widget.addtx(
      titlenew,
      double.parse(amountnew),
      _selecteddate,
    );
    Navigator.of(context).pop();
  }

  void _presentdatepicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selecteddate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: mediaquery.viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: titlecontroller,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountcontroller,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selecteddate == null
                          ? 'No date Chosen!'
                          : 'Picked Date: ${DateFormat.yMd().format(_selecteddate)}'),
                    ),
                    Adaptive_falt('Choose Date', _presentdatepicker),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: _submitData,
                child: Text(
                  'Add Transaction',
                ),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
              )
            ],
          ),
        ),
      ),
    );
  }
}
