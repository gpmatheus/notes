
class InvalidFileException implements Exception {
  final String message;

  InvalidFileException(this.message);

  @override
  String toString() {
    return 'InvalidFileException: $message';
  }
}