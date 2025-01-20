
import 'package:logger/logger.dart';

class FormattedLogger {

  static Logger? _logger;

  static Logger get logger {
    _logger ??= Logger(
        printer: PrettyPrinter(
            methodCount: 2,
            errorMethodCount: 8,
            lineLength: 120,
            colors: true,
            printEmojis: true,
            dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        ),
      );
    return _logger!;
  }
}