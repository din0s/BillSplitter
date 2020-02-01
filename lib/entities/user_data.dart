import 'package:bill_splitter/entities/denomination.dart';
import 'package:tuple/tuple.dart';

class Wallet {
  final money = Map<Denomination, int>();
  final Set<Tuple2<Denomination, String>> deposits = Set();

  Wallet() {
    Denomination.values.forEach((d) => money[d] = 0);
  }

  Wallet.from(Map<Denomination, int> map) {
    Denomination.values.forEach((d) => money[d] = 0);
    Denomination.values
        .where((d) => map[d] != null)
        .forEach((d) => money[d] += map[d]);
  }

  void add(Wallet other, String from) {
    Denomination.values.forEach((d) {
      money[d] += other.money[d];
      if (other.money[d] != 0) {
        deposits.add(Tuple2(d, from));
      }
    });
  }

  Tuple2<Denomination, String> pop(Denomination denom) {
    if (money[denom] == 0) {
      return null;
    }
    money[denom]--;
    final donor = deposits.firstWhere((t) => t.item1.index == denom.index);
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
  final Map<Denomination, int> paid;
  final Map<Denomination, int> owed;
  final Wallet refund = Wallet();

  String get details {
    final paidList = List<String>();
    final owedList = List<String>();
    Denomination.values.reversed.forEach((d) {
      final label = denomLabel(d);
      if (paid != null && paid[d] != 0) {
        paidList.add("${paid[d]} x $label");
      }
      if (owed != null && owed[d] != 0) {
        owedList.add("${owed[d]} x $label");
      }
    });
    if (paidList.isEmpty && owedList.isEmpty) {
      return price == 0 ? "FREE" : "CANNOT AFFORD TO PAY";
    }
    if (paidList.isEmpty) {
      return "OWED: ${owedList.join(", ")}";
    }
    if (owedList.isEmpty) {
      return paidList.join(", ");
    }
    return "${paidList.join(", ")}\nOWED: ${owedList.join(", ")}";
  }

  bool get hasRefund => refund.total != 0.0;

  String get refundInfo {
    final info = List<String>();
    refund.money.forEach((k, v) {
      for (int i = 0; i < v; i++) {
        final tup = refund.deposits.firstWhere((t) => t.item1.index == k.index);
        refund.deposits.remove(tup);
        info.add("- 1 x ${denomLabel(k)} from ${tup.item2}");
      }
    });
    return "REFUND:\n${info.join("\n")}";
  }

  UserPayoff(this.name, this.price, this.paid, this.owed);
}
