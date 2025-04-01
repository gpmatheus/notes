
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:notes/data/repository/interfaces/user_repository_interface.dart';
import 'package:notes/utils/formatted_logger.dart';

class LogoutViewmodel extends ChangeNotifier {

  LogoutViewmodel({
    required UserRepositoryInterface userRepository,
  }) :
    _userRepository = userRepository;

  final UserRepositoryInterface _userRepository;
  final Logger _logger = FormattedLogger.instance;

  bool _loading = false;
  bool get loading => _loading;

  void signOut() async {
    _loading = true;
    notifyListeners();
    
    try {
      await _userRepository.signOut();
    } on Exception catch (e) {
      _logger.e(e);
    }

    _loading = false;
    notifyListeners();
  }
}