
import 'package:notes/domain/model/user/user.dart' as domain;
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepositoryInterface {

  Future<domain.User?> get currentUser;

  Stream<domain.User?> get authStateChanges;

  Future<void> createUser({
    required String name,
    required String email,
    required String password,
  });

  Future<void> sendVerificationEmail();

  Future<void> signInWithCredencial(AuthCredential credential);

  Future<void> signIn({
    required String email, 
    required String password
  });

  Future<void> signOut();

  Future<void> resetPassword(String email);

  Future<void> changeEmail(String newEmail);

  Future<void> changePassword(String password);

  Future<void> reloadUser();

}