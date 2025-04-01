
import 'package:flutter/material.dart';
import 'package:notes/data/repository/interfaces/user_repository_interface.dart';
import 'package:notes/domain/model/user/user.dart';
import 'package:notes/ui/auth/profile/widgets/profile_details.dart';

class ProfileViewmodel extends ChangeNotifier {

  ProfileViewmodel({
    required UserRepositoryInterface userRepository,
  }) :
    _userRepository = userRepository;

  final UserRepositoryInterface _userRepository;

  Stream<User?> get user => _userRepository.authStateChanges;

  void navigateToProfileDetails(BuildContext context) async {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => ProfileDetails(
          viewmodel: ProfileViewmodel(
            userRepository: _userRepository,
          ),
        )
      )
    );
  }
}