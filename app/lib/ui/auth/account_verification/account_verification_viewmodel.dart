
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:notes/data/repository/interfaces/user_repository_interface.dart';
import 'package:notes/domain/model/user/user.dart';

class AccountVerificationViewmodel extends ChangeNotifier {

  AccountVerificationViewmodel({
    required UserRepositoryInterface userRepository,
  }) :
    _userRepository = userRepository,
    _user = userRepository.authStateChanges;

  final UserRepositoryInterface _userRepository;
  final TextEditingController _controller = TextEditingController();
  final Stream<User?> _user;
  final StreamController<Stream<bool>> _sentVerificationEmail = StreamController<Stream<bool>>();

  Stream<User?> get user => _user;
  Stream<Stream<bool>> get sentVerificationEmail => _sentVerificationEmail.stream;
  TextEditingController get controller => _controller;

  void navigateToRoot(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void sendVerificationEmail() {
    _userRepository.sendVerificationEmail();
  }
}