
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';
import 'package:notes/config/firebase.dart';
import 'package:notes/data/services/interfaces/model/exceptions/invalid_input_exception.dart';
import 'package:notes/data/services/interfaces/model/exceptions/unauthenticated_exception.dart';
import 'package:notes/data/services/interfaces/user_service.dart';
import 'package:notes/domain/model/user/user.dart' as domain;
import 'package:notes/firebase_options.dart';
import 'package:notes/utils/formatted_logger.dart';

class RemoteUserFirebaseAuthService implements UserService {

  final Logger _logger = FormattedLogger.instance;
  late final FirebaseAuth _firebaseAuth;
  late final Future<FirebaseApp> _firebaseApp;

  RemoteUserFirebaseAuthService() {
    try {
      _firebaseApp = Future.value(Firebase.app(APPNAME));
      _firebaseAuth = FirebaseAuth.instance;
      reloadUser();
    } on Exception catch (_) {
      _logger.i('Initializing Firebase app...');
      _firebaseApp = Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).then((app) {
        _firebaseAuth = FirebaseAuth.instance;
        reloadUser();
        return app;
      });
    }
  }

  @override
  Future<Stream<domain.User?>> get authStateChanges async {
    await _firebaseApp;
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) {
        return null;
      }
      return domain.User(
        id: user.uid,
        email: user.email,
        name: user.displayName,
        photoUrl: user.photoURL,
        verified: user.emailVerified,
        active: user.isAnonymous,
      );
    });
  }

  @override
  Future<void> changePassword(String newPassword) async {
    await _firebaseApp;
    if (_firebaseAuth.currentUser == null) throw UnauthenticatedException('No user logged in');
    try {
      await _firebaseAuth.currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      _logger.e(e);
      throw InvalidInputException('Information procided is invalid');
    }
  }

  @override
  Future<domain.User> createUser({
    required String name, 
    required String email, 
    required String password}) async {

    await _firebaseApp;
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = credential.user!;
      await user.updateDisplayName(name);
      return domain.User(
        id: user.uid, 
        verified: user.emailVerified, 
        active: !user.isAnonymous,
      );
    } on FirebaseAuthException catch (e) {
      _logger.e(e);
      throw InvalidInputException('Information procided is invalid');
    }
  }

  @override
  Future<domain.User?> get currentUser async {
    await _firebaseApp;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return null;
    }
    return domain.User(
      id: user.uid,
      email: user.email,
      name: user.displayName,
      photoUrl: user.photoURL,
      verified: user.emailVerified,
      active: user.isAnonymous,
    );
  }

  @override
  Future<void> reloadUser() async {
    await _firebaseApp;
    await _firebaseAuth.currentUser?.reload();
  }

  @override
  Future<void> sendVerificationEmail() async {
    await _firebaseApp;
    try {
      await _firebaseAuth.currentUser!.sendEmailVerification();
      print('sending verification email');
    } on Exception catch (e) {
      _logger.e(e);
    }
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _firebaseApp;
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      
    } on FirebaseAuthException catch (e) {
      _logger.e(e);
      throw InvalidInputException('Error in authentication: ${e.message}');
    } catch (e) {
      _logger.e(e);
    }
  }

  @override
  Future<void> signInWithGoogle({
    required String? accessToken,
    required String? idToken,
  }) async {
    
    await _firebaseApp;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: accessToken,
      idToken: idToken,
    );

    try {
      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      _logger.e(e);
      throw InvalidInputException('Invalid input was provided');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseApp;
    return _firebaseAuth.signOut();
  }
  
  @override
  Future<void> changeImage(String newUrl) async {
    await _firebaseApp;
    if (_firebaseAuth.currentUser == null) throw UnauthenticatedException('User not authenticated');
    await _firebaseAuth.currentUser!.updatePhotoURL(newUrl);
  }
  
  @override
  Future<void> changeName(String newName) async {
    await _firebaseApp;
    if (_firebaseAuth.currentUser == null) throw UnauthenticatedException('User not authenticated');
    await _firebaseAuth.currentUser!.updateDisplayName(newName);
    // await reloadUser();
  }

}