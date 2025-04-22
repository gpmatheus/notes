
import 'package:firebase_core/firebase_core.dart';
import 'package:notes/firebase_options.dart';

class FirebaseConfig {
  
  static Future<FirebaseApp> getFirebaseApp() async {
    try {
      return Firebase.app();
    } on Exception catch (_) {
      return Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  }
}