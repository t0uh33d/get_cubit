# Get Cubit

The GetCubit package provides a way to manage instances of the Cubit class in a Dart/Flutter application. The Cubit class is a state management pattern used in the Flutter framework, which allows for the separation of state management from the widgets that use that state. By using the GetCubit package, developers can register a singleton or multiple instances of the Cubit class using unique identifiers. This allows for easy access and manipulation of the state across the entire application.

The package includes several methods for managing these instances:

- `put`: This method is used to register an instance of the Cubit class. It takes in a Cubit instance and an optional id parameter, which can be used to create multiple unique instances of the same Cubit class. The method returns the registered instance of the Cubit class.

- `find`: This method is used to retrieve a registered instance of the Cubit class. It takes in the Cubit class type and an optional id parameter, and returns the corresponding instance. If the instance is not found, it throws an error.

- `delete`: This method is used to delete a registered instance of the Cubit class. It takes in the Cubit class type and an optional id parameter, and removes the corresponding instance from the internal map.

- `deleteAllCubitInstances`: This method is used to delete all registered instances of a Cubit class. It takes in the Cubit class type, and removes all instances of that class from the internal map.

- `flush`: This method is used to delete all registered instances of Cubit class, with the option to exclude certain instances from being deleted.

- `getAllInstanceIds`: This method is used to list all unique identifiers linked to instances of a cubit class.

It also provides functionality for cubit-to-cubit communication, and listing all the unique identifiers linked to instances of a cubit.

In order to use this package, it needs to be added as a dependency in the pubspec.yaml file of the flutter project, and then imported in the dart file where it is being used. Once imported, it can be used to register and manage instances of the Cubit class throughout the application.

It can be used to create a singleton instance of a cubit, which means that the same instance will be shared across the entire application, or it can be used to create multiple instances of the same cubit class, each with a unique identifier. It also provides an easy way to delete instances of the Cubit class when they are no longer needed.

Overall, the GetCubit package provides a useful way to manage instances of the Cubit class in a Dart/Flutter application, making it easier to separate state management from the widgets that use that state, and allowing for easy access and manipulation of that state throughout the entire application.

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
GetCubit.put(CounterCubit());

// register an existing instance
CounterCubit counterCubit = CounterCubit();
GetCubit.put(counterCubit);

// another way to register an existing instance
counterCubit.addInstanceToGetCubit<CounterCubit>();
```

### Creating multiple instances using unique identifiers

```dart
// register a new instance with id
GetCubit.put(CounterCubit(), id : "cubit_1");
GetCubit.put(CounterCubit(), id : "cubit_2");

// register an existing instance with id
CounterCubit counterCubit1 = CounterCubit();
CounterCubit counterCubit2 = CounterCubit();
GetCubit.put(counterCubit1, id : "cubit_1");
GetCubit.put(counterCubit1, id : "cubit_2");

// another way to register an existing instance with id
counterCubit1.addInstanceToGetCubit<CounterCubit>(id : "cubit_1");
counterCubit2.addInstanceToGetCubit<CounterCubit>(id : "cubit_2");
```

### Accessing the registered instances

The registered instances can be accessed using `GetCubit.find()`

```dart
// file_1.dart :
final CounterCubit counterCubit = GetCubit.put(CounterCubit());
print(counterCubit.state); // 0
counterCubit.increment();

// file_2.dart
print(GetCubit.find<CounterCubit>().state); // 1
```

### Accessing the registered instances using id

```dart
// file_1.dart :
final CounterCubit counterCubit1 = GetCubit.put(CounterCubit(), id : "cubit_1");
final CounterCubit counterCubit2 = GetCubit.put(CounterCubit(), id : "cubit_2");
counterCubit1.emit(5);
counterCubit2.emit(10);

// file_2.dart
print(GetCubit.find<CounterCubit>(id : "cubit_1").state); // 5
print(GetCubit.find<CounterCubit>(id : "cubit_2").state); // 10
```

### deleting a registered instance

```dart
 GetCubit.delete<CounterCubit>(); // without id
 GetCubit.delete<CounterCubit>(id : "cubit_1"); // with id
```

### deleting all the registered instances linked of a cubit

```dart
GetCubit.find<CounterCubit>().deleteAllInstances();
```

### Listing all the unique ids linked to instances of a cubit

```dart
GetCubit.put(CounterCubit(),id : "c1");
GetCubit.put(CounterCubit(),id : "c2");
GetCubit.put(CounterCubit(),id : "c3");
GetCubit.put(CounterCubit(),id : "c4");
GetCubit.put(CounterCubit(),id : "c5");

List<String> ids = GetCubit.find<CounterCubit>().getAllInstanceIds();
print(ids); // [c1,c2,c3,c4,c5]
```

### Clear all instances of cubit from memory

```dart
GetCubit.flush();
```
