
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:notes/data/repository/interfaces/user_repository_interface.dart';
import 'package:notes/domain/model/user/user.dart';
import 'package:notes/utils/formatted_logger.dart';

class AccountVerificationViewmodel extends ChangeNotifier {

  AccountVerificationViewmodel({
    required UserRepositoryInterface userRepository,
  }) :
    _userRepository = userRepository,
    _user = userRepository.currentUser {
      sendEmailVerification();
    }

  final Logger _logger = FormattedLogger.instance;
  final UserRepositoryInterface _userRepository;

  bool _loading = false;
  final Future<User?> _user;
  final Completer<void> _completer = Completer<void>();

  bool get loading => _loading;
  Future<User?> get user => _user;
  Future<void> get sendVerification => _completer.future;

  void sendEmailVerification() async {
    _loading = true;
    notifyListeners();

    await _userRepository.sendVerificationEmail();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _userRepository.reloadUser();
      _userRepository.currentUser.then((user) {
        if (user != null && user.verified) {
          timer.cancel();
          _completer.complete();
          _logger.i('User verified!');
        }
      });
    });

    _loading = false;
    notifyListeners();
  }

  void navigateToRoot(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}