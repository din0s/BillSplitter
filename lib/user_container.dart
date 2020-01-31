import 'package:bill_splitter/bloc/money/exports.dart';
import 'package:bill_splitter/fragments/circle_button.dart';
import 'package:bill_splitter/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserContainer extends StatefulWidget {
  @override
  _UserContainerState createState() => _UserContainerState();

  final UserData data = UserData();
}

class _UserContainerState extends State<UserContainer> {
  final _balance = MoneyBloc();
  final _bController = TextEditingController(text: "0.0");

  @override
  void dispose() {
    _balance.close();
    _bController.dispose();
    super.dispose();
  }

  void _addAmt(int amt) {
    _balance.add(Add(amt));
  }

  void _removeAmt(int amt) {
    _balance.add(Remove(amt));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildNameField(),
        _buildPriceField(),
        _buildMoneySelector(),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      autovalidate: true,
      decoration: InputDecoration(labelText: "Name"),
      onSaved: (val) => {widget.data.name = val},
      initialValue: "Bob",
      validator: (val) {
        if (val.isEmpty) {
          return "Your name cannot be empty!";
        }
        return null;
      },
    );
  }

  Widget _buildPriceField() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Container(
        child: TextFormField(
          autovalidate: true,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Price",
            suffix: Text("€", style: TextStyle(fontSize: 18)),
          ),
          onSaved: (val) => {widget.data.price = double.parse(val)},
          initialValue: "0.0",
          validator: (val) {
            if (val.isEmpty) {
              return "Enter the price you paid!";
            }
            double value = double.tryParse(val);
            if (value == null || value < 0) {
              return "That's not a valid number!";
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildMoneySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BlocListener<MoneyBloc, int>(
          bloc: _balance,
          listener: (context, state) {
            _bController.text = "${state / 100.0}";
          },
          child: TextFormField(
            controller: _bController,
            enabled: false,
            onSaved: (val) => {widget.data.balance = _balance.state / 100.0},
            decoration: InputDecoration(
              labelText: "Balance",
              suffix: Text("€", style: TextStyle(fontSize: 18)),
            ),
          ),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Coin("10c", 10, _addAmt, _removeAmt),
            Coin("20c", 20, _addAmt, _removeAmt),
            Coin("50c", 50, _addAmt, _removeAmt),
            Coin("1e", 100, _addAmt, _removeAmt),
            Coin("2e", 200, _addAmt, _removeAmt),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Bill("5e", 500, _addAmt, _removeAmt),
            Bill("10e", 1000, _addAmt, _removeAmt),
            Bill("20e", 2000, _addAmt, _removeAmt),
          ],
        ),
      ],
    );
  }
}

class Coin extends CircleButton {
  Coin(String text, int amt, dynamic add, dynamic remove)
      : super(
          Text(text),
          () => add(amt),
          onLongPress: () => remove(amt),
          color: Colors.orange,
        );
}

class Bill extends FlatButton {
  Bill(String text, int amt, dynamic add, dynamic remove)
      : super(
          child: Text(text),
          onPressed: () => add(amt),
          onLongPress: () => remove(amt),
          color: Colors.green,
        );
}
