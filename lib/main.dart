import 'package:bill_splitter/entities/user_data.dart';
import 'package:bill_splitter/fragments/circle_button.dart';
import 'package:bill_splitter/result_popup.dart';
import 'package:bill_splitter/user_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bill Splitter',
      theme: ThemeData(
        accentColor: Colors.blueAccent,
        brightness: Brightness.dark,
        textSelectionHandleColor: Colors.blueAccent,
      ),
      home: MyHomePage(title: 'Bill Splitter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _key = GlobalKey<ScaffoldState>();
  final _form = GlobalKey<FormState>();
  final _users = List<UserContainer>();

  @override
  void initState() {
    super.initState();
    _addUser();
  }

  void _addUser() {
    setState(() {
      _users.add(UserContainer());
    });
  }

  void _removeUser() {
    setState(() {
      _users.removeLast();
    });
  }

  void _error(String text) {
    _key.currentState.hideCurrentSnackBar();
    _key.currentState.showSnackBar(
      SnackBar(
        content: Text(text, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _calculate() {
    if (_users.length == 1) {
      _error("Add more than one person!");
    } else if (!_form.currentState.validate()) {
      _error("There are errors in the input fields!");
    } else {
      _key.currentState.hideCurrentSnackBar();
      _form.currentState.save();
      final userData = List<UserDebit>();
      _users.forEach((e) => userData.add(e.data));
      showDialog(context: context, child: ResultPopup(userData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      key: _key,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ..._users.map((e) {
                int index = _users.indexOf(e) + 1;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Person #$index",
                      style: TextStyle(fontSize: 20),
                    ),
                    e,
                    Divider(
                      color: Colors.white,
                      thickness: 2,
                      height: 48,
                    ),
                  ],
                );
              }),
              Row(
                children: <Widget>[
                  CircleButton(Text("+"), onPress: _addUser),
                  SizedBox(width: 8),
                  if (_users.length > 1)
                    CircleButton(
                      Text("-"),
                      onPress: _removeUser,
                      color: Colors.red,
                    ),
                ],
              ),
              Center(
                child: MaterialButton(
                  color: Colors.blueAccent,
                  child: Text("CALCULATE"),
                  onPressed: _calculate,
                  height: 40,
                  minWidth: 200,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
