class LocationException implements Exception {
  String message;

  LocationException([this.message = 'Something went wrong']) {
    message = 'Location Exception: $message';
  }

  @override
  String toString() {
    return message;
  }
}
