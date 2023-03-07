// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';

part 'cubit_ext.dart';

class GetCubit {
  static final GetCubit _getCubit = GetCubit._internal();

  factory GetCubit() {
    return _getCubit;
  }

  GetCubit._internal();

  // HashMap to link the instances to cubit names and id
  static final Map<String, Cubit> _mp = {};

  /// adds the instance of the cubit, if the instance already exists then returns the same
  ///
  /// Provide an id to create multiple unique instances
  static T put<T extends Cubit>(T cubit,
      {String? id, bool avoidOverriding = false}) {
    String key = _getKey(T, id);
    if (_mp.containsKey(key)) {
      if (id != null && avoidOverriding) {
        throw ("Instance of Cubit:$T with id:\"$id\" already exists, please use distinct id");
      }
      return _mp[key] as T;
    }
    _mp[key] = cubit;
    return _mp[key] as T;
  }

  /// delete the instance of the cubit
  static void delete<T extends Cubit>({String? id}) {
    String key = _getKey(T, id);
    if (_mp.containsKey(key)) {
      _mp[key]?.close();
      _mp.remove(key);
    }
  }

  /// find an instance of a cubit
  static T find<T extends Cubit>(
      {String? id, bool autoCreate = false, T? onAutoCreate}) {
    String key = _getKey(T, id);
    if (_mp.containsKey(key)) {
      return _mp[key] as T;
    }
    if (autoCreate && onAutoCreate != null) {
      return put<T>(onAutoCreate, id: id);
    }

    if (id == null) {
      throw ("Instance of Cubit:$T not found, please use GetCubit().put($T()) to create an instance of this cubit");
    } else {
      throw ("Instance of Cubit:$T with id:\"$id\" not found, please use GetCubit().put($T(), id : \"$id\") to create an instance of this cubit");
    }
  }

  /// generate the key to link instance in the HashMap
  static String _getKey(Type t, String? id) {
    return id == null ? t.toString() : t.toString() + id;
  }

  // delete all the instances of a cubit
  static void deleteAllCubitInstances<T extends Cubit>() {
    String k = T.toString();
    List<String> keys = _mp.keys.toList();
    for (int idx = 0; idx < keys.length; idx++) {
      if (keys[idx].contains(k)) {
        _mp[keys[idx]]?.close();
        _mp.remove(keys[idx]);
      }
    }
  }

  static void flush({List<FlushExclusions>? flushExclusions}) {
    List<String> keys = _mp.keys.toList();
    Set<String> exclusionKeys = <String>{};
    if (flushExclusions != null) {
      for (int idx = 0; idx < flushExclusions.length; idx++) {
        if (flushExclusions[idx].excludeAllRelatedInstances!) {
          exclusionKeys = {
            ...exclusionKeys,
            ..._relatedKeys(flushExclusions[idx].cubitType)
          };
        } else {
          exclusionKeys.add(
              _getKey(flushExclusions[idx].cubitType, flushExclusions[idx].id));
        }
      }
    }
    _flusher(keys, exclusionKeys);
  }

  static void _flusher(List<String> keys, Set<String> exclusionKeys) {
    for (int idx = 0; idx < keys.length; idx++) {
      if (exclusionKeys.contains(keys[idx])) continue;
      _mp[keys[idx]]?.close();
      _mp.remove(keys[idx]);
    }
  }

  static List<String> get getAllRegisteredInstanceKeys => _mp.keys.toList();

  static Set<String> _relatedKeys(Type type) {
    String key = _getKey(type, null);
    List<String> keys = _mp.keys.toList();
    Set<String> relKeys = <String>{};
    for (int idx = 0; idx < keys.length; idx++) {
      if (keys[idx].contains(key)) {
        relKeys.add(keys[idx]);
      }
    }
    return relKeys;
  }
}

class FlushExclusions {
  final Type cubitType;
  final String? id;

  /// if set to true, excludes all the related instances of the cubit from flushing
  bool? excludeAllRelatedInstances;

  FlushExclusions({
    required this.cubitType,
    this.id,
    this.excludeAllRelatedInstances = false,
  });
}
