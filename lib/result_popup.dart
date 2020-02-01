import 'package:bill_splitter/entities/denomination.dart';
import 'package:bill_splitter/entities/user_data.dart';
import 'package:bill_splitter/fragments/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ResultPopup extends StatelessWidget {
  final List<UserPayoff> payoff = List();
  final Wallet bank = Wallet();

  ResultPopup(List<UserDebit> debit) {
    _charge(debit);
    _refund();
  }

  void _charge(List<UserDebit> debit) {
    debit.forEach((u) {
      Map<Denomination, int> balance = Map.from(u.balance);
      Wallet payment = Wallet();
      if (_check(u.price, balance, payment, true) == 0) {
        bank.add(payment, u.name);
        payoff.add(UserPayoff(u.name, u.price, payment.money, null));
      } else {
        balance = Map.from(u.balance);
        payment = Wallet();
        if (_check(u.price, balance, payment, false) < 0) {
          bank.add(payment, u.name);
          payoff.add(UserPayoff(
            u.name,
            u.price,
            payment.money,
            _findExtra(u.price, payment.total),
          ));
        } else {
          payoff.add(UserPayoff(u.name, u.price, null, null));
        }
      }
    });
  }

  int _check(
      int remainder,
      Map<Denomination, int> balance,
      Wallet payment,
      bool exact,
      ) {
    for (int i = Denomination.values.length - 1; i >= 0; i--) {
      if (exact ? remainder == 0 : remainder <= 0) {
        break;
      }
      Denomination d = Denomination.values[i];
      if (balance[d] == 0) {
        continue;
      }
      int value = denomCents(d);
      if (remainder >= value || !exact) {
        i++;
        balance[d]--;
        remainder -= value;
        payment.money[d]++;
      }
    }
    return remainder;
  }

  int _findExtra(int paid, int total) {
    int diff = total - paid;
    final result = Wallet();
    for (int i = Denomination.values.length - 1; i >= 0; i--) {
      if (diff == 0) {
        break;
      }
      Denomination denom = Denomination.values[i];
      int value = denomCents(denom);
      if (diff >= value) {
        diff -= value;
        result.money[denom]++;
        i++;
      }
    }
    return result.total;
  }

  void _refund() {
    payoff.where((u) => u.owed != null).forEach((u) {
      var refund = u.owed;
      for (int i = Denomination.values.length - 1; i >= 0; i--) {
        if (refund == 0 || !bank.hasDeposits) {
          break;
        }
        Denomination denom = Denomination.values[i];
        if (bank.money[denom] == 0) {
          continue;
        }
        final value = denomCents(denom);
        if (refund >= value) {
          final withdraw = bank.pop(denom);
          if (withdraw == null) {
            continue;
          }
          final _map = Map<Denomination, int>();
          _map[withdraw.item1] = 1;
          u.refund.add(Wallet.from(_map), withdraw.item2);
          refund -= value;
          i++;
        }
      }
      u.owed = refund;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: 420,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    "Bank: ${bank.totalDecimal}€",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                CircleButton(
                  Text("x"),
                  onPress: () => Navigator.of(context).pop(),
                  color: Colors.red,
                ),
              ],
            ),
            Container(
              height: 350,
              child: ListView.builder(
                itemCount: payoff.length,
                itemBuilder: (context, index) {
                  UserPayoff user = payoff[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              "${user.name} (${user.price / 100.0}€)",
                              style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            SizedBox(width: 8),
                            if (user.owed != null && user.owed > 0)
                              Text(
                                "-${user.owed / 100.0}€",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${user.details}",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        if (user.hasRefund)
                          Text(
                            "${user.refundInfo}",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
