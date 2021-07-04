import './chartbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List recenttransactions;
  Chart(this.recenttransactions);
  List<Map<String, Object>> get groupedtransactionvalues {
    return (List.generate(7, (index) {
      final weekday = DateTime.now().subtract(Duration(days: index));
      double totalsum = 0.0;
      for (int i = 0; i < recenttransactions.length; i++) {
        if (recenttransactions[i].time.day == weekday.day &&
            recenttransactions[i].time.month == weekday.month &&
            recenttransactions[i].time.year == weekday.year) {
          totalsum += recenttransactions[i].amount;
        }
      }
      return ({
        'day': DateFormat.E().format(weekday).substring(0, 1),
        'amount': totalsum
      });
    })).reversed.toList();
  }

  double get totalspent {
    return groupedtransactionvalues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedtransactionvalues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: Chartbar(
                  data['day'],
                  data['amount'],
                  totalspent == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalspent),
            );
          }).toList(),
        ),
      ),
    );
  }
}
