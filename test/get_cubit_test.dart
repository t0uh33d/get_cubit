import 'package:flutter_test/flutter_test.dart';

import 'package:get_cubit/get_cubit.dart';

void main() {
  test('check GetCubit put and find', () {
    GetCubit().put(CounterCubit());
    GetCubit().find<CounterCubit>().emit(1);
    GetCubit().find<CounterCubit>().emit(2);
    expect(GetCubit().put(CounterCubit()).state, 2);
  });

  test('delete instance call', () {
    GetCubit().put(CounterCubit());
    GetCubit().delete<CounterCubit>();
  });

  test('id based instance check', () {
    GetCubit().put(CounterCubit(i: 0), id: 'id_0');
    GetCubit().put(CounterCubit(i: 1), id: 'id_1');
    GetCubit().put(CounterCubit(i: 2), id: 'id_2');
    GetCubit().put(CounterCubit(i: 3), id: 'id_3');
    expect(GetCubit().find<CounterCubit>(id: 'id_0').state, 0);
    expect(GetCubit().find<CounterCubit>(id: 'id_1').state, 1);
    expect(GetCubit().find<CounterCubit>(id: 'id_2').state, 2);
    expect(GetCubit().find<CounterCubit>(id: 'id_3').state, 3);
    expect(CounterCubit().getAllInstanceIds().length, 4);
    CounterCubit().deleteAllInstances();
    expect(CounterCubit().getAllInstanceIds().length, 0);
  });

  test('add instance to get cubit', () {
    final CounterCubit counterCubit = CounterCubit(i: 5);
    expect(counterCubit.state, 5);
    counterCubit.addInstanceToGetCubit<CounterCubit>();
    expect(GetCubit().find<CounterCubit>().state, 5);
  });

  test('delete instance based on id', () {
    for (int i = 0; i < 10; i++) {
      GetCubit().put(CounterCubit(i: i), id: '$i');
    }
    print(CounterCubit().getAllInstanceIds());
    GetCubit().delete<CounterCubit>(id: '5');
    print(CounterCubit().getAllInstanceIds());
    CounterCubit().deleteAllInstances();
    print(CounterCubit().getAllInstanceIds());
  });
}

class CounterCubit extends Cubit<int> {
  CounterCubit({int? i}) : super(i ?? 0);
}
