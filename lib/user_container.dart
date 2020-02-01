import 'package:bill_splitter/bloc/money/exports.dart';
import 'package:bill_splitter/entities/denomination.dart';
import 'package:bill_splitter/entities/user_data.dart';
import 'package:bill_splitter/fragments/money_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserContainer extends StatefulWidget {
  @override
  _UserContainerState createState() => _UserContainerState();

  final UserDebit data = UserDebit();
}

class _UserContainerState extends State<UserContainer> {
  final _nController = TextEditingController(text: "Bob");
  final _nFocus = FocusNode();
  final _pController = TextEditingController(text: "0.0");
  final _pFocus = FocusNode();
  final _bController = TextEditingController(text: "0.0");

  @override
  void initState() {
    super.initState();
    _nFocus.addListener(() {
      if (_nFocus.hasFocus) {
        _nController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _nController.text.length,
        );
      }
    });
    _pFocus.addListener(() {
      if (_pFocus.hasFocus) {
        _pController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _pController.text.length,
        );
      }
    });
  }

  @override
  void dispose() {
    _nController.dispose();
    _nFocus.dispose();
    _pController.dispose();
    _pFocus.dispose();
    _bController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MoneyBloc>(
      create: (context) => MoneyBloc(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildNameField(),
          _buildPriceField(),
          _buildMoneySelector(),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      autovalidate: true,
      decoration: InputDecoration(labelText: "Name"),
      onSaved: (val) => {widget.data.name = val},
      controller: _nController,
      focusNode: _nFocus,
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
          onSaved: (val) =>
              {widget.data.price = (double.parse(val) * 100).round()},
          controller: _pController,
          focusNode: _pFocus,
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
    return BlocConsumer<MoneyBloc, MoneyState>(
      listener: (context, state) => _bController.text = "${state.total}",
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: _bController,
                    enabled: false,
                    onSaved: (val) => widget.data.balance = state.balance,
                    decoration: InputDecoration(
                      labelText: "Balance",
                      suffix: Text("€", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: MaterialButton(
                    child: Text("Clear"),
                    color: Colors.red,
                    onPressed: () {
                      BlocProvider.of<MoneyBloc>(context).add(Clear());
                    },
                    minWidth: 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Coin(Denomination.CENT_10),
                    Coin(Denomination.CENT_20),
                    Coin(Denomination.CENT_50),
                    Coin(Denomination.EURO_1),
                    Coin(Denomination.EURO_2),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Bill(Denomination.EURO_5),
                    Bill(Denomination.EURO_10),
                    Bill(Denomination.EURO_20),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
