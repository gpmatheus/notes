
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/data/repository/interfaces/user_repository_interface.dart';
import 'package:notes/domain/model/user/user.dart';
import 'package:notes/ui/auth/account_verification/account_verification_viewmodel.dart';
import 'package:notes/ui/auth/account_verification/widgets/account_verification.dart';
import 'package:notes/ui/auth/profile/widgets/profile_details.dart';
import 'package:provider/provider.dart';

class ProfileViewmodel extends ChangeNotifier {

  ProfileViewmodel({
    required UserRepositoryInterface userRepository,
  }) :
    _userRepository = userRepository {
      _loadUser();
    }

  final UserRepositoryInterface _userRepository;
  final TextEditingController _nameController = TextEditingController();
  File? imageFile;
  User? _user;
  bool _loading = false;

  User? get user => _user;
  Stream<User?> get userStream => _userRepository.authStateChanges;
  TextEditingController get nameController => _nameController;
  bool get loading => _loading;

  Future<void> updateName() async {
    await _userRepository.updateName(nameController.text);
    await _loadUser();
  }

  Future<void> updateProfileImage() async {
    if (imageFile == null) {
      return;
    }
    await _userRepository.updateProfileImage(imageFile!);
  }

  Future<void> _loadUser() async {
    _loading = true;
    notifyListeners();
    _user = await _userRepository.currentUser;
    if (_user != null && _user!.name != null) {
      _nameController.text = _user!.name!;
    }
    _loading = false;
    notifyListeners();
  }

  void navigateToEmailVerification(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountVerification(
          viewmodel: AccountVerificationViewmodel(
            userRepository: context.read(),
          ),
        )
      )
    );
  }

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