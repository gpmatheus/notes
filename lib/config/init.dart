
import 'package:notes/config/configurations/sqlite_config.dart';

abstract class AppConfig {

  Future<void> execute();
}

class Init {
  final List<AppConfig> _configs = [
    SqliteConfig()
  ];

  Future<void> configure() async {
    for (AppConfig config in _configs) {
      await config.execute();
    }
  }
}