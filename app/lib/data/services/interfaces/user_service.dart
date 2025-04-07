
import 'package:notes/domain/model/user/user.dart';

abstract class UserService {

  Future<void> changePassword(String newPassword);

  Future<User> createUser({
    required String name,
    required String email,
    required String password,
  });

  Future<void> sendVerificationEmail();

  Future<Stream<User?>> get authStateChanges;

  Future<User?> get currentUser;

  Future<void> signIn({
    required String email,
    required String password,
  });

  Future<void> signInWithGoogle({
    required String? accessToken,
    required String? idToken,
  });

  Future<void> signOut();

  Future<void> reloadUser();

  Future<void> changeImage(String newUrl);

  Future<void> changeName(String newName);
}