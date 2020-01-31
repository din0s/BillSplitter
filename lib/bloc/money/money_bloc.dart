import 'dart:math';

import 'package:bill_splitter/bloc/money/exports.dart';
import 'package:bloc/bloc.dart';

class MoneyBloc extends Bloc<MoneyEvent, int> {
  @override
  int get initialState => 0;

  @override
  Stream<int> mapEventToState(MoneyEvent event) async* {
    if (event is Add) {
      yield state + event.amount;
    } else if (event is Remove) {
      yield max(state - event.amount, 0);
    } else if (event is Clear) {
      yield 0;
    }
  }
}
