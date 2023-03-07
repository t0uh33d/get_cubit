import 'package:flutter_bloc/flutter_bloc.dart';

class CounterSelectorCubit extends Cubit<int> {
  CounterSelectorCubit() : super(0);

  void selectCounter(int i) => emit(i);
}
