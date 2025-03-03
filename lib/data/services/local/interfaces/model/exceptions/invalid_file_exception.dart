
import 'package:notes/data/services/local/interfaces/model/exceptions/invalid_input_exception.dart';

class InvalidFileException implements InvalidInputException {
  final String message;

  InvalidFileException(this.message);

  @override
  String toString() {
    return 'InvalidFileException: $message';
  }
}