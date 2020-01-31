import 'package:bill_splitter/entities/denomination.dart';

class MoneyState {
  Map<Denomination, int> balance;

  MoneyState() {
    balance = Map();
    Denomination.values.forEach((e) => balance[e] = 0);
  }

  MoneyState.from(MoneyState state) {
    balance = Map.from(state.balance);
  }

  bool add(Denomination denomination) {
    if (balance[denomination] >= 99) {
      return false;
    }
    balance[denomination]++;
    return true;
  }

  bool remove(Denomination denomination) {
    if (balance[denomination] < 1) {
      return false;
    }
    balance[denomination]--;
    return true;
  }

  double get total {
    double amt = 0;
    balance.forEach((k, v) => amt += denomModifier(k) * v);
    return amt;
  }
}
