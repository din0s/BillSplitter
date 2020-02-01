import 'package:bill_splitter/entities/denomination.dart';
import 'package:tuple/tuple.dart';

class Wallet {
  final money = Map<Denomination, int>();
  final List<Tuple2<Denomination, String>> deposits = List();

  Wallet() {
    Denomination.values.forEach((d) => money[d] = 0);
  }

  Wallet.from(Map<Denomination, int> map) {
    Denomination.values.forEach((d) => money[d] = 0);
    Denomination.values
        .where((d) => map[d] != null)
        .forEach((d) => money[d] += map[d]);
  }

  void copy(Wallet other) {
    Denomination.values
        .where((d) => other.money[d] != null)
        .forEach((d) => money[d] += other.money[d]);
    deposits.clear();
    deposits.addAll(other.deposits);
  }

  void add(Wallet other, String from) {
    Denomination.values.forEach((d) {
      money[d] += other.money[d];
      if (other.money[d] != 0) {
        deposits.add(Tuple2(d, from));
        for (int i = 0; i < other.money[d]; i++) {
          deposits.add(Tuple2(d, from));
        }
      }
    });
  }

  bool get hasDeposits => deposits.isNotEmpty;

  Tuple2<Denomination, String> pop(Denomination denom) {
    if (money[denom] == 0 || !deposits.any((t) => t.item1 == denom)) {
      return null;
    }
    money[denom]--;
    final donor = deposits.firstWhere((t) => t.item1 == denom);
    deposits.remove(donor);
    return donor;
  }

  int get total {
    int res = 0;
    Denomination.values.forEach((d) => res += money[d] * denomCents(d));
    return res;
  }

  double get totalDecimal => total / 100.0;
}

class UserDebit {
  String name;
  int price;
  Map<Denomination, int> balance;
}

class UserPayoff {
  final String name;
  final int price;
  int owed;
  final Map<Denomination, int> paid;
  final Wallet refund = Wallet();

  String get details {
    final paidList = List<String>();
    Denomination.values.reversed.forEach((d) {
      final label = denomLabel(d);
      if (paid != null && paid[d] != 0) {
        paidList.add("${paid[d]} x $label");
      }
    });
    if (paidList.isEmpty) {
      return price == 0 ? "FREE" : "CANNOT AFFORD TO PAY";
    }
    return paidList.join(", ");
  }

  bool get hasRefund => refund.total != 0.0;

  String get refundInfo {
    final info = List<String>();
    refund.money.forEach((k, v) {
      for (int i = 0; i < v; i++) {
        final tup = refund.deposits.firstWhere((t) => t.item1 == k);
        refund.deposits.remove(tup);
        info.add("- 1 x ${denomLabel(k)} from ${tup.item2}");
      }
    });
    return "REFUND:\n${info.join("\n")}";
  }

  UserPayoff(this.name, this.price, this.paid, { this.owed });
}
