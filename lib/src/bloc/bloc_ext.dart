part of 'get_bloc_impl.dart';

extension GetBlocInstance on Bloc {
  /// delete all the instances of the cubit from [GetBloc]
  void deleteAllInstances() {
    List<String> keys = GetBloc._mp.keys.toList();
    for (int idx = 0; idx < keys.length; idx++) {
      if (keys[idx].contains(runtimeType.toString())) {
        GetBloc._mp[keys[idx]]?.close();
        GetBloc._mp.remove(keys[idx]);
      }
    }
  }

  /// add the current instance of the bloc to [GetBloc]
  void addInstanceToGetBloc<T extends Bloc>({String? id}) {
    if (runtimeType.toString() != T.toString()) {
      throw ("Please specify the correct type of bloc addInstanceToGetBloc<$runtimeType>");
    }
    GetBloc.put<T>(this as T, id: id);
  }

  /// get all the ids with which the cubit was intialized in [GetBloc]
  List<String> getAllInstanceIds() {
    String k = runtimeType.toString();
    List<String> keys = GetBloc._mp.keys.toList();
    List<String> res = [];
    for (int idx = 0; idx < keys.length; idx++) {
      if (keys[idx].contains(k)) {
        String sanitizedKey = keys[idx].replaceAll(k, '');
        if (sanitizedKey.isEmpty) continue;
        res.add(sanitizedKey);
      }
    }
    return res;
  }
}
