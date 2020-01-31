abstract class MoneyEvent {
  final int amount;

  MoneyEvent(this.amount);
}

class Add extends MoneyEvent {
  Add(int amount) : super(amount);
}

class Remove extends MoneyEvent {
  Remove(int amount) : super(amount);
}

class Clear extends MoneyEvent {
  Clear() : super(0);
}
