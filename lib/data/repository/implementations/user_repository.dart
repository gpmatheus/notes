

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:logger/logger.dart';
import 'package:notes/config/firebase.dart';
import 'package:notes/data/services/interfaces/model/exceptions/invalid_input_exception.dart';
import 'package:notes/domain/model/user/user.dart' as domain;
import 'package:notes/data/repository/interfaces/user_repository_interface.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/utils/formatted_logger.dart';

class UserRepository implements UserRepositoryInterface {

  final Logger _logger = FormattedLogger.instance;
  late final FirebaseAuth _firebaseAuth;
  late final Future<FirebaseApp> _firebaseApp;

  UserRepository() {
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
  Future<void> changePassword(String password) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<void> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      _logger.e(e);
      if (e.code == 'email-already-in-use') {
        throw InvalidInputException('Este e-mail já está em uso.');
      } 
      if (e.code == 'weak-password') {
        throw InvalidInputException('A senha fornecida é muito fraca.');
      
      } 
      if (e.code == 'invalid-email') {
        throw InvalidInputException('O e-mail fornecido é inválido.');
      }
      throw InvalidInputException('Erro na autenticação: ${e.message}');
    } catch (e) {
      _logger.e(e);
    }
  }

  @override
  Future<void> sendVerificationEmail() async {
    try {
      await _firebaseApp;
      await _firebaseAuth.currentUser!.sendEmailVerification();
    } on Exception catch (e) {
      _logger.e(e);
    }
  }

  @override
  Stream<domain.User?> get authStateChanges {
    return FirebaseAuth.instance.authStateChanges().map((user) {
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
  Future<domain.User?> get currentUser async {
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
  Future<void> resetPassword(String email) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      
    } on FirebaseAuthException catch (e) {
      _logger.e(e);
      if (e.code == 'email-already-in-use') {
        throw InvalidInputException('Este e-mail já está em uso.');
      } 
      if (e.code == 'weak-password') {
        throw InvalidInputException('A senha fornecida é muito fraca.');
      
      } 
      if (e.code == 'invalid-email') {
        throw InvalidInputException('O e-mail fornecido é inválido.');
      }
      throw InvalidInputException('Erro na autenticação: ${e.message}');
    } catch (e) {
      _logger.e(e);
    }
  }

  @override
  Future<void> signInWithCredencial(AuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      _logger.e(e);
    }
  }

  @override
  Future<void> signOut() {
    return FirebaseAuth.instance.signOut();
  }
  
  @override
  Future<void> changeEmail(String newEmail) async {
    await Future.delayed(const Duration(seconds: 3));
  }
  
  @override
  Future<void> reloadUser() async {
    _firebaseAuth.currentUser?.reload();
  }

}