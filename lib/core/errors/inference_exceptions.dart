class UnsupportedDeviceException implements Exception {
  final String message;
  UnsupportedDeviceException(this.message);

  @override
  String toString() => 'UnsupportedDeviceException: $message';
}

class ModelLoadException implements Exception {
  final String message;
  ModelLoadException(this.message);

  @override
  String toString() => 'ModelLoadException: $message';
}

class OOMException implements Exception {
  final String message;
  OOMException(this.message);

  @override
  String toString() => 'OOMException: $message';
}
