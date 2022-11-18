import 'package:bloc/bloc.dart';
part 'cubit_ext.dart';

class GetCubit {
  static final GetCubit _getCubit = GetCubit._internal();

  factory GetCubit() {
    return _getCubit;
  }

  GetCubit._internal();

  // HashMap to link the instances to cubit names and id
  final Map<String, Cubit> _mp = {};

  /// adds the instance of the cubit, if the instance already exists then returns the same
  ///
  /// Provide an id to create multiple unique instances
  T put<T extends Cubit>(T cubit, {String? id}) {
    String key = _getKey(T, id);
    if (_mp.containsKey(key)) {
      if (id != null) {
        throw ("Instance of Cubit:$T with id:\"$id\" already exists, please use distinct id");
      }
      return _mp[key] as T;
    }
    _mp[key] = cubit;
    return _mp[key] as T;
  }

  /// delete the instance of the cubit
  void delete<T extends Cubit>({String? id}) {
    String key = _getKey(T, id);
    if (_mp.containsKey(key)) {
      _mp[key]?.close();
      _mp.remove(key);
    }
  }

  /// find an instance of a cubit
  T find<T extends Cubit>({String? id}) {
    String key = _getKey(T, id);
    if (_mp.containsKey(key)) {
      return _mp[key] as T;
    }
    if (id == null) {
      throw ("Instance of Cubit:$T not found, please use GetCubit().put($T()) to create an instance of this cubit");
    } else {
      throw ("Instance of Cubit:$T with id:\"$id\" not found, please use GetCubit().put($T(), id : \"$id\") to create an instance of this cubit");
    }
  }

  /// generate the key to link instance in the HashMap
  String _getKey(Type t, String? id) {
    return id == null ? t.toString() : t.toString() + id;
  }

  // deletes all the existing get cubit instances
  void deleteAllInstances() {
    List<String> keys = _mp.keys.toList();
    for (int idx = 0; idx < keys.length; idx++) {
      if (keys[idx].contains(runtimeType.toString())) {
        _mp[keys[idx]]?.close();
        _mp.remove(keys[idx]);
      }
    }
  }
}
