
class SigninException implements Exception {
  final String message;

  SigninException(this.message);

  @override
  String toString() {
    return 'SigninException: $message';
  }
}