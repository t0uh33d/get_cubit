import 'package:bloc/bloc.dart';
import 'package:get_cubit/src/common_widgets/flush_exclusion.dart';

part 'bloc_ext.dart';

class GetBloc {
  static final GetBloc _getBloc = GetBloc._internal();

  factory GetBloc() {
    return _getBloc;
  }

  GetBloc._internal();

  // HashMap to link the instances to Bloc names and id
  static final Map<String, Bloc> _mp = {};

  /// adds the instance of the Bloc, if the instance already exists then returns the same
  ///
  /// Provide an id to create multiple unique instances
  static T put<T extends Bloc>(T bloc,
      {String? id, bool avoidOverriding = false}) {
    String key = _getKey(T, id);
    if (_mp.containsKey(key)) {
      if (id != null && avoidOverriding) {
        throw ("Instance of Bloc:$T with id:\"$id\" already exists, please use distinct id");
      }
      return _mp[key] as T;
    }
    _mp[key] = bloc;
    return _mp[key] as T;
  }

  /// delete the instance of the Bloc
  static void delete<T extends Bloc>({String? id}) {
    String key = _getKey(T, id);
    if (_mp.containsKey(key)) {
      _mp[key]?.close();
      _mp.remove(key);
    }
  }

  /// find an instance of a Bloc
  static T find<T extends Bloc>(
      {String? id, bool autoCreate = false, T? onAutoCreate}) {
    String key = _getKey(T, id);
    if (_mp.containsKey(key)) {
      return _mp[key] as T;
    }
    if (autoCreate && onAutoCreate != null) {
      return put<T>(onAutoCreate, id: id);
    }

    if (id == null) {
      throw ("Instance of Bloc:$T not found, please use GetBloc().put($T()) to create an instance of this Bloc");
    } else {
      throw ("Instance of Bloc:$T with id:\"$id\" not found, please use GetBloc().put($T(), id : \"$id\") to create an instance of this Bloc");
    }
  }

  static bool exists<T extends Bloc>({String? id}) =>
      _mp.containsKey(_getKey(T, id));

  /// generate the key to link instance in the HashMap
  static String _getKey(Type t, String? id) {
    return id == null ? t.toString() : t.toString() + id;
  }

  // delete all the instances of a Bloc
  static void deleteAllBlocInstances<T extends Bloc>() {
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
            ..._relatedKeys(flushExclusions[idx].stateType)
          };
        } else {
          exclusionKeys.add(
              _getKey(flushExclusions[idx].stateType, flushExclusions[idx].id));
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
