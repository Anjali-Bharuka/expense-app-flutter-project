import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import './widgets/transactionlist.dart';
import './widgets/newtransaction.dart';
import 'package:flutter/material.dart';
import './models/transaction.dart';
import './widgets/chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense App',
      home: MyHomePage(),
      theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.amberAccent,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                button: TextStyle(color: Colors.white),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                    title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          )),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _newtransactions(String txtitle, double txamount, DateTime chosentime) {
    final tx = transaction(
      id: DateTime.now().toString(),
      title: txtitle,
      amount: txamount,
      time: chosentime,
    );
    setState(() {
      _usertransactions.add(tx);
    });
  }

  bool _showval = true;

  final List<transaction> _usertransactions = [
    //   (transaction(
    //       id: 't1', title: 'chocolates', amount: 100.00, time: DateTime.now())),
    //   transaction(
    //       id: 'd2', title: 'Groceries', amount: 366.78, time: DateTime.now())
  ];
  List<transaction> get _recentransactions {
    return (_usertransactions.where((tx) {
      return tx.time.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    })).toList();
  }

  void _deletetransaction(String id) {
    setState(() {
      _usertransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  void _startnewtransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: newtransaction(_newtransactions),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  List<Widget> _buildlandscapecontent(
      MediaQueryData mediaquery, AppBar appBar, Widget listwidget) {
    return [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'Show Chart',
          style: Theme.of(context).textTheme.title,
        ),
        Switch.adaptive(
            value: _showval,
            onChanged: (val) {
              setState(() {
                _showval = val;
              });
            }),
      ]),
      _showval
          ? Container(
              child: Chart(_recentransactions),
              height: (mediaquery.size.height -
                      appBar.preferredSize.height -
                      mediaquery.padding.top) *
                  0.3,
            )
          : listwidget
    ];
  }

  List<Widget> _buildPortraitcontent(
      MediaQueryData mediaquery, AppBar appBar, Widget listwidget) {
    return [
      Container(
        child: Chart(_recentransactions),
        height: (mediaquery.size.height -
                appBar.preferredSize.height -
                mediaquery.padding.top) *
            0.3,
      ),
      listwidget
    ];
  }

  Widget _buildappbar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Expense App'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                child: Icon(CupertinoIcons.add),
                onTap: () => _startnewtransaction(context),
              )
            ]),
          )
        : AppBar(
            title: Text('Expense App'),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startnewtransaction(context),
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    final islandscape = mediaquery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar = _buildappbar();
    final listwidget = Container(
      height: (mediaquery.size.height -
              appBar.preferredSize.height -
              mediaquery.padding.top) *
          0.7,
      child: TransactionList(_usertransactions, _deletetransaction),
    );
    final bodypage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (islandscape)
              ..._buildlandscapecontent(mediaquery, appBar, listwidget),
            if (!islandscape)
              ..._buildPortraitcontent(mediaquery, appBar, listwidget),
            //if (!islandscape) listwidget,
            if (islandscape)
              ..._buildlandscapecontent(mediaquery, appBar, listwidget),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: bodypage,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: bodypage,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startnewtransaction(context),
                  ),
          );
  }
}
