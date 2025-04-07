

import 'dart:async';
import 'dart:io';

import 'package:notes/data/services/interfaces/user_service.dart';
import 'package:notes/domain/model/user/user.dart' as domain;
import 'package:notes/data/repository/interfaces/user_repository_interface.dart';

class UserRepository implements UserRepositoryInterface {

  UserRepository({
    required UserService userService,
  }) :
    _userService = userService;

  final UserService _userService;

  @override
  Future<void> changePassword(String password) async {
    try {
      await _userService.changePassword(password);
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    
    try {
      await _userService.createUser(
        name: name, 
        email: email, 
        password: password
      );
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> sendVerificationEmail() async {

    try {
      await _userService.sendVerificationEmail();
      while (true) {
        final user = await _userService.currentUser;
        if (user != null && user.verified) {
          break;
        }
        await Future.delayed(const Duration(seconds: 5));
      }
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Stream<domain.User?> get authStateChanges {
    return Stream.fromFuture(_userService.authStateChanges).asyncExpand((stream) => stream);
  }

  @override
  Future<domain.User?> get currentUser async => _userService.currentUser;


  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      return await _userService.signIn(email: email, password: password);
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> signInWithCredencial({
    required String? accessToken,
    required String? idToken,
  }) async {
    try {
      return await _userService.signInWithGoogle(
        accessToken: accessToken, 
        idToken: idToken
      );
    } on Exception catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    return _userService.signOut();
  }
  
  @override
  Future<void> updateName(String name) async {
    await Future.delayed(const Duration(seconds: 5));
    return _userService.changeName(name);
  }

  @override
  Future<void> updateProfileImage(File image) async {
    _userService.changeImage('');
  }

}