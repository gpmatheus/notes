
import 'package:firebase_core/firebase_core.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/utils/formatted_logger.dart';

class FirebaseConfig {
  
  static Future<FirebaseApp> getFirebaseApp() async {
    try {
      return Firebase.app();
    } on Exception catch (_) {
      FormattedLogger.instance.i('Creating database...');
      return Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }
}