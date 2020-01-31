import 'package:bill_splitter/bloc/money/exports.dart';
import 'package:bloc/bloc.dart';

class MoneyBloc extends Bloc<MoneyEvent, MoneyState> {
  @override
  MoneyState get initialState => MoneyState();

  @override
  Stream<MoneyState> mapEventToState(MoneyEvent event) async* {
    if (event is Add) {
      yield MoneyState.from(state)..add(event.denomination);
    } else if (event is Remove) {
      yield MoneyState.from(state)..remove(event.denomination);
    } else if (event is Clear) {
      yield MoneyState();
    }
  }
}
