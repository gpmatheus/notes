
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/data/services/interfaces/model/exceptions/invalid_input_exception.dart';
import 'package:notes/data/services/interfaces/model/exceptions/network_exception.dart';
import 'package:notes/data/services/interfaces/model/exceptions/not_found_exception.dart';
import 'package:notes/data/services/interfaces/model/exceptions/signin_exception.dart';
import 'package:notes/data/services/interfaces/model/exceptions/unauthenticated_exception.dart';
import 'package:notes/data/services/interfaces/user_service.dart';
import 'package:notes/domain/model/user/user.dart' as domain;

class RemoteUserFirebaseAuthService implements UserService {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Stream<domain.User?>> get authStateChanges async {
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
        remoteSave: true,
      );
    });
  }

  @override
  Future<void> changePassword(String newPassword) async {
    if (_firebaseAuth.currentUser == null) throw UnauthenticatedException('No user logged in');
    try {
      await _firebaseAuth.currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw InvalidInputException('The password is too weak.');
      } else if (e.code == 'required-recent-login') {
        throw SigninException('The must have sign in again.');
      } else {
        throw Exception('An unknown error occurred.');
      }
    }
  }

  @override
  Future<domain.User> createUser({
    required String name, 
    required String email, 
    required String password}) async {

    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = credential.user!;
      await user.updateDisplayName(name);
      return domain.User(
        id: user.uid, 
        verified: user.emailVerified, 
        active: !user.isAnonymous,
        remoteSave: true,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw InvalidInputException('The email address is already in use by another account.');
      } else if (e.code == 'invalid-email') {
        throw InvalidInputException('The email address is not valid.');
      } else if (e.code == 'operation-not-allowed') {
        throw InvalidInputException('Email/password accounts are not enabled.');
      } else if (e.code == 'weak-password') {
        throw InvalidInputException('The password is too weak.');
      } else {
        throw Exception('An unknown error occurred.');
      }
    }
  }

  @override
  Future<domain.User?> get currentUser async {
    final user = _firebaseAuth.currentUser;
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
      remoteSave: true,
    );
  }

  @override
  Future<void> reloadUser() async {
    await _firebaseAuth.currentUser?.reload();
  }

  @override
  Future<void> sendVerificationEmail() async {
    await _firebaseAuth.currentUser!.sendEmailVerification();
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw InvalidInputException('The email address is not valid.');
      } else if (e.code == 'user-disabled') {
        throw InvalidInputException('The user is desabled');
      } else if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        throw NotFoundException('User not found or wrong password.');
      } else if (e.code == 'user-token-expired') {
        throw SigninException('User must sign in again.');
      } else if (e.code == 'network-request-failed') {
        throw NetworkException('No internet connection.');
      } else {
        throw Exception('An unknown error occurred.');
      }
    }
  }

  @override
  Future<void> signInWithGoogle({
    required String? accessToken,
    required String? idToken,
  }) async {
    
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: accessToken,
      idToken: idToken,
    );

    try {
      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (_) {
      throw InvalidInputException('Invalid input was provided.');
    }
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
  
  @override
  Future<void> changeImage(String newUrl) async {
    if (_firebaseAuth.currentUser == null) throw UnauthenticatedException('User not authenticated');
    await _firebaseAuth.currentUser!.updatePhotoURL(newUrl);
  }
  
  @override
  Future<void> changeName(String newName) async {
    if (_firebaseAuth.currentUser == null) throw UnauthenticatedException('User not authenticated');
    await _firebaseAuth.currentUser!.updateDisplayName(newName);
  }

}