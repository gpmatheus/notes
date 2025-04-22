
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes/data/repository/interfaces/user_repository_interface.dart';
import 'package:notes/data/services/interfaces/model/exceptions/invalid_input_exception.dart';

class LoginViewmodel extends ChangeNotifier {

  LoginViewmodel({
    required UserRepositoryInterface userRepository,
  }) : _userRepository = userRepository;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserRepositoryInterface _userRepository;

  final _formKey = GlobalKey<FormState>();
  bool _loginFail = false;
  bool _loading = false;
  bool _passwordObscured = true;
  bool get loading => _loading;
  bool get loginFail => _loginFail;
  bool get passwordObscured => _passwordObscured;
  Key get formKey => _formKey;

  Future<bool> signInWithGoogle() async {
    _loading = true;
    notifyListeners();

    try {
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return false;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      await _userRepository.signInWithCredencial(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
    } on Exception catch (_) {
      return false;
    }

    _loading = false;
    notifyListeners();
    return true;
  }

  Future<bool> signInWithEmailAndPassword(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return false;

    _loading = true;
    notifyListeners();

    bool success = false;
    try {
      await _userRepository.signIn(
        email: emailController.text,
        password: passwordController.text,
      );
      success = true;
    } on InvalidInputException catch (_) {
      success = false;
    } on Exception catch (_) {
      success = false;
    }

    _loading = false;
    _loginFail = !success;
    notifyListeners();
    return success;
  }

  void switchPasswordVisibility() {
    _passwordObscured = !_passwordObscured;
    notifyListeners();
  }

  void navigateToRoot(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return 'Email is required';
    final RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(emailController.text) ? null : 'Invalid email';
  }
}