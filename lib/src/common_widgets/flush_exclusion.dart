class FlushExclusions {
  final Type stateType;
  final String? id;

  /// if set to true, excludes all the related instances of the cubit from flushing
  bool? excludeAllRelatedInstances;

  FlushExclusions({
    required this.stateType,
    this.id,
    this.excludeAllRelatedInstances = false,
  });
}
