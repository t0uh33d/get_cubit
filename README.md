# Get Cubit

A package to help handle Cubit instances across the app.

- Register a singleton instance of a cubit and access across the app
- Register multiple instances of a cubit using unique identifiers
- Easily handle cubit to cubit communications

# Installation

To use this package, add `get_cubit` to your pubsec.yaml file.

or run the below command

```dart
pub add get_cubit
```

# Usage

example of cubit :

```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
```

### Registering a cubit instance

To register an instance of the `CounterCubit` class

```dart
// register a new instance
GetCubit().put(CounterCubit());

// register an existing instance
CounterCubit counterCubit = CounterCubit();
GetCubit().put(counterCubit);

// another way to register an existing instance
counterCubit.addInstanceToGetCubit<CounterCubit>();
```

### Creating multiple instances using unique identifiers

```dart
// register a new instance with id
GetCubit().put(CounterCubit(), id : "cubit_1");
GetCubit().put(CounterCubit(), id : "cubit_2");

// register an existing instance with id
CounterCubit counterCubit1 = CounterCubit();
CounterCubit counterCubit2 = CounterCubit();
GetCubit().put(counterCubit1, id : "cubit_1");
GetCubit().put(counterCubit1, id : "cubit_2");

// another way to register an existing instance with id
counterCubit1.addInstanceToGetCubit<CounterCubit>(id : "cubit_1");
counterCubit2.addInstanceToGetCubit<CounterCubit>(id : "cubit_2");
```

### Accessing the registered instances

The registered instances can be accessed using `GetCubit().find()`

```dart
// file_1.dart :
final CounterCubit counterCubit = GetCubit().put(CounterCubit());
print(counterCubit.state); // 0
counterCubit.increment();

// file_2.dart
print(GetCubit().find<CounterCubit>().state); // 1
```

### Accessing the registered instances using id

```dart
// file_1.dart :
final CounterCubit counterCubit1 = GetCubit().put(CounterCubit(), id : "cubit_1");
final CounterCubit counterCubit2 = GetCubit().put(CounterCubit(), id : "cubit_2");
counterCubit1.emit(5);
counterCubit2.emit(10);

// file_2.dart
print(GetCubit().find<CounterCubit>(id : "cubit_1").state); // 5
print(GetCubit().find<CounterCubit>(id : "cubit_2").state); // 10
```

### deleting a registered instance

```dart
 GetCubit().delete<CounterCubit>(); // without id
 GetCubit().delete<CounterCubit>(id : "cubit_1"); // with id
```

### deleting all the registered instances linked of a cubit

```dart
GetCubit().find<CounterCubit>().deleteAllInstances();
```

### Listing all the unique ids linked to instances of a cubit

```dart
GetCubit().put(CounterCubit(),id : "c1");
GetCubit().put(CounterCubit(),id : "c2");
GetCubit().put(CounterCubit(),id : "c3");
GetCubit().put(CounterCubit(),id : "c4");
GetCubit().put(CounterCubit(),id : "c5");

List<String> ids = GetCubit().find<CounterCubit>().getAllInstanceIds();
print(ids); // [c1,c2,c3,c4,c5]
```
