
import 'package:flutter/material.dart';
import 'package:notes/ui/auth/login/login_viewmodel.dart';
import 'package:notes/ui/core/app_logo.dart';
import 'package:notes/ui/core/loading_screen.dart';

class LoginWithEmail extends StatelessWidget {
  const LoginWithEmail({
    super.key,
    required LoginViewmodel viewmodel,
  }) :
    _viewmodel = viewmodel;

  final LoginViewmodel _viewmodel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListenableBuilder(
        listenable: _viewmodel,
        builder: (context, _) {
          return LoadingScreen(
            loading: _viewmodel.loading,
            screen: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 42.0,
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _viewmodel.formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppLogo(),
                            const Text(
                              'Sign in with email',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextFormField(
                              controller: _viewmodel.emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                              ),
                              validator: _viewmodel.validateEmail,
                            ),
                            TextFormField(
                              controller: _viewmodel.passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  padding: const EdgeInsetsDirectional.only(end: 8.0),
                                  icon: Icon(
                                    _viewmodel.passwordObscured
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  ),
                                  onPressed: _viewmodel.switchPasswordVisibility,
                                ),
                              ),
                              obscureText: _viewmodel.passwordObscured,
                            ),
                            const SizedBox(height: 16),
                            if (_viewmodel.loginFail) ... [
                              Text(
                                'Email or password is incorrect',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () async { 
                                final success = await _viewmodel.signInWithEmailAndPassword(context);

                                if (success) {
                                  await showDialog(
                                    // ignore: use_build_context_synchronously
                                    context: context, 
                                    builder: (context) {
                                      return AlertDialog(
                                        content: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(height: 26.0),
                                            Center(
                                              child: Icon(
                                                Icons.check_rounded,
                                                size: 50,
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }, 
                                            child: const Text('Ok')
                                          ),
                                        ],
                                      );
                                    }
                                  );
                                  // ignore: use_build_context_synchronously
                                  _viewmodel.navigateToRoot(context);
                                }
                              },
                              child: const Text('Sign in'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}