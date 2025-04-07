
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:notes/data/repository/interfaces/user_repository_interface.dart';
import 'package:notes/data/services/interfaces/model/exceptions/invalid_input_exception.dart';
import 'package:notes/ui/auth/account_verification/account_verification_viewmodel.dart';
import 'package:notes/ui/auth/login/login_viewmodel.dart';
import 'package:notes/ui/auth/login/widgets/login.dart';
import 'package:notes/ui/auth/account_verification/widgets/account_verification.dart';
import 'package:provider/provider.dart';
import 'package:notes/utils/formatted_logger.dart';

class RegisterViewmodel extends ChangeNotifier {

  RegisterViewmodel({
    required UserRepositoryInterface userRepository,
  }) :
    _userRepository = userRepository;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final UserRepositoryInterface _userRepository;
  final Logger _logger = FormattedLogger.instance;
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  bool _passwordObscured = true;
  bool get loading => _loading;
  bool get passwordObscured => _passwordObscured;
  Key get formKey => _formKey;

  Future<bool> register() async {
    if (_loading) return false;

    bool success = false;
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _loading = true;
      notifyListeners();

      try {
        await _userRepository.createUser(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text,
        );
        success = true;
      } on InvalidInputException catch (e) {
        _logger.e(e);
        success = false;
      } on Exception catch (e) {
        _logger.e(e);
        success = false;
      }

      _loading = false;
      notifyListeners();
    }
    return success;
  }

  void switchPasswordVisibility() {
    _passwordObscured = !_passwordObscured;
    notifyListeners();
  }

  void navigateToRoot(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void navigateToSignIn(BuildContext context) {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) {
          return Login(
            viewmodel: LoginViewmodel(
              userRepository: context.read(),
            )
          );
        }
      )
    );
  }

  void navigateToEmailVerification(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return AccountVerification(
            viewmodel: AccountVerificationViewmodel(
              userRepository: context.read(),
            )
          );
        }
      )
    );
  }

  String? validateName(String? name) {
    if (name == null || name.isEmpty) return 'First name is required';
    return name.length >= 3 ? null : 'First name must be at least 3 characters';
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email is required';
    final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(emailController.text) ? null : 'Invalid email';
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) return 'Password is required';
    return password.length >= 6 ? null : 'Password must be at least 6 characters';
  }

  String? validateConfirmPassword(String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) return 'Confirm password is required';
    return confirmPassword == passwordController.text ? null : 'Passwords do not match';
  }
}