
import 'package:notes/data/services/interfaces/model/exceptions/invalid_input_exception.dart';

class InvalidFileException implements InvalidInputException {
  @override
  final String message;

  InvalidFileException(this.message);

  @override
  String toString() {
    return 'InvalidFileException: $message';
  }
}