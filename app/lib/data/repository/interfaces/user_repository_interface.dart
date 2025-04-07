
import 'dart:io';

import 'package:notes/domain/model/user/user.dart' as domain;

abstract class UserRepositoryInterface {

  Future<domain.User?> get currentUser;

  Stream<domain.User?> get authStateChanges;

  Future<void> createUser({
    required String name,
    required String email,
    required String password,
  });

  Future<void> sendVerificationEmail();

  Future<void> signInWithCredencial({
    required String? accessToken,
    required String? idToken,
  });

  Future<void> signIn({
    required String email, 
    required String password
  });

  Future<void> signOut();

  Future<void> changePassword(String password);

  Future<void> updateName(String name);

  Future<void> updateProfileImage(File image);

}