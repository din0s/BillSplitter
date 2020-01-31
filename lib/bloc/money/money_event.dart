import 'package:bill_splitter/entities/denomination.dart';

abstract class MoneyEvent {}

abstract class BalanceEvent extends MoneyEvent {
  final Denomination denomination;

  BalanceEvent(this.denomination);
}

class Add extends BalanceEvent {
  Add(Denomination denom) : super(denom);
}

class Remove extends BalanceEvent {
  Remove(Denomination denom) : super(denom);
}

class Clear extends MoneyEvent {}
