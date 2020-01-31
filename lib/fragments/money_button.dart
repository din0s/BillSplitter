import 'package:bill_splitter/bloc/money/exports.dart';
import 'package:bill_splitter/entities/denomination.dart';
import 'package:bill_splitter/fragments/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MoneyButton extends StatelessWidget {
  final Widget widget;
  final Denomination denom;

  MoneyButton(
    this.widget,
    this.denom,
  );

  @override
  Widget build(BuildContext context) {
    void _add(Denomination m) {
      BlocProvider.of<MoneyBloc>(context).add(Add(m));
    }

    void _remove(Denomination m) {
      BlocProvider.of<MoneyBloc>(context).add(Remove(m));
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: <Widget>[
          GestureDetector(
            child: widget,
            onTap: () => _add(denom),
            onLongPress: () => _remove(denom),
          ),
          Padding(
            padding: EdgeInsets.only(left: 4),
            child: Container(
              width: 14,
              child: Text(
                "${BlocProvider.of<MoneyBloc>(context).state.balance[denom]}",
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Coin extends MoneyButton {
  Coin(Denomination denom)
      : super(
          CircleButton(
            Text(denomLabel(denom)),
            color: Colors.orange,
          ),
          denom,
        );
}

class Bill extends MoneyButton {
  Bill(Denomination denom)
      : super(
          Container(
            child: Center(child: Text(denomLabel(denom))),
            color: Colors.green,
            padding: EdgeInsets.all(12),
            width: 80,
          ),
          denom,
        );
}
