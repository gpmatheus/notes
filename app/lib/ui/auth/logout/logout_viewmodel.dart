
import 'package:flutter/material.dart';
import 'package:notes/data/repository/interfaces/user_repository_interface.dart';

class LogoutViewmodel extends ChangeNotifier {

  LogoutViewmodel({
    required UserRepositoryInterface userRepository,
  }) :
    _userRepository = userRepository;

  final UserRepositoryInterface _userRepository;

  bool _loading = false;
  bool get loading => _loading;

  void signOut() async {
    _loading = true;
    notifyListeners();
    
    try {
      await _userRepository.signOut();
    } on Exception catch (_) {}

    _loading = false;
    notifyListeners();
  }
}