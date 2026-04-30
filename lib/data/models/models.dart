import 'package:flutter/material.dart';

class Txn {
  final String merchant;
  final String category;
  final double amount;
  final IconData icon;
  final String? avatarSeed;
  final String time;
  final String note;
  final String card;
  Txn({
    required this.merchant,
    required this.category,
    required this.amount,
    required this.icon,
    this.avatarSeed,
    required this.time,
    required this.note,
    required this.card,
  });
}

class CardModel {
  final String last4;
  final String label;
  final String balance;
  final String holder;
  final String network;
  const CardModel({
    required this.last4,
    required this.label,
    required this.balance,
    required this.holder,
    required this.network,
  });

  double get balanceNum => double.tryParse(balance.replaceAll(RegExp(r'[\$,]'), '')) ?? 0;
}

class Contact {
  final String name;
  final String avatarSeed;
  const Contact(this.name, this.avatarSeed);
}

class DayBar {
  final String d;
  final String date;
  final double out;
  final double inAmt;
  const DayBar(this.d, this.date, this.out, this.inAmt);
}
