import 'package:expenseapp/models/transaction.dart';
import 'package:expenseapp/widgets/transactionItem.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<transaction> transactions;
  final Function deletetx;
  TransactionList(this.transactions, this.deletetx);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        child: transactions.isEmpty
            ? Column(
                children: [
                  Text(
                    'No Transactions yet!!',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              )
            : ListView(
                children: transactions
                    .map(
                      (tx) => TransactionItem(
                        transactions: tx,
                        deletetx: deletetx,
                        key: ValueKey(tx.id),
                      ),
                    )
                    .toList(),
              ),
      );
    });
  }
}
