import 'package:flutter/material.dart';
import '../models/models.dart';

const kCards = <CardModel>[
  CardModel(last4: '5025', label: 'Signature', balance: '\$12,840.50', holder: 'TINO WELL', network: 'VISA'),
  CardModel(last4: '2840', label: 'Savings', balance: '\$38,210.00', holder: 'TINO WELL', network: 'MASTERCARD'),
  CardModel(last4: '7621', label: 'Travel', balance: '\$1,428.12', holder: 'T. WELL', network: 'AMEX'),
  CardModel(last4: '3104', label: 'Virtual', balance: '\$5,290.75', holder: 'TINO WELL', network: 'VIRTUAL'),
];

final kTxns = <Txn>[
  Txn(merchant: 'Blue Bottle Coffee', category: 'Food & drink', amount: -6.40,
    icon: Icons.coffee_outlined, time: '9:24 AM', note: 'SoMa · San Francisco', card: 'Signature ••5025'),
  Txn(merchant: 'Alec Koder', category: 'Transfer in', amount: 100.00,
    icon: Icons.person, avatarSeed: 'Alec', time: '8:50 AM', note: 'Peer-to-peer transfer', card: 'Signature ••5025'),
  Txn(merchant: 'Spotify', category: 'Entertainment', amount: -9.99,
    icon: Icons.music_note_outlined, time: 'Yesterday', note: 'Monthly subscription', card: 'Signature ••5025'),
  Txn(merchant: 'Whole Foods', category: 'Groceries', amount: -84.22,
    icon: Icons.shopping_basket_outlined, time: 'Yesterday', note: '4th & King, SF', card: 'Signature ••5025'),
  Txn(merchant: 'Pawan Kumar', category: 'Rent', amount: -1600,
    icon: Icons.person, avatarSeed: 'Pawan', time: 'Wednesday', note: 'October rent', card: 'Signature ••5025'),
];

const kContacts = <Contact>[
  Contact('Mike', 'Mike'),
  Contact('Pawan', 'Pawan'),
  Contact('Dash', 'Dash'),
  Contact('Chizi', 'Chizi'),
  Contact('Tadas', 'Tadas'),
  Contact('Tim', 'Tim'),
];

const kBars = <DayBar>[
  DayBar('M', 'Oct 18', 45, 120),
  DayBar('T', 'Oct 19', 85, 0),
  DayBar('W', 'Oct 20', 210, 1600),
  DayBar('T', 'Oct 21', 28, 0),
  DayBar('F', 'Oct 22', 92, 0),
  DayBar('S', 'Oct 23', 45, 0),
  DayBar('S', 'Oct 24', 12, 100),
];

class CategoryStat {
  final String name;
  final double value;
  final int pct;
  const CategoryStat(this.name, this.value, this.pct);
}

const kCategories = <CategoryStat>[
  CategoryStat('Groceries', 418, 34),
  CategoryStat('Dining', 242, 20),
  CategoryStat('Transport', 186, 15),
  CategoryStat('Shopping', 164, 13),
  CategoryStat('Other', 218, 18),
];
