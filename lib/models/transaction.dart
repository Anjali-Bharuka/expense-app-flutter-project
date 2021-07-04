import 'package:flutter/foundation.dart';

class transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime time;
  transaction(
      {@required this.id,
      @required this.title,
      @required this.amount,
      @required this.time});
}
