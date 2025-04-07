
import 'package:flutter/material.dart';
import 'package:notes/ui/auth/register/register_viewmodel.dart';
import 'package:notes/ui/core/app_logo.dart';
import 'package:notes/ui/core/loading_screen.dart';

class Register extends StatelessWidget {
  const Register({
    super.key,
    required RegisterViewmodel viewmodel,
  }) : _viewmodel = viewmodel;

  final RegisterViewmodel _viewmodel;

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
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _viewmodel.formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppLogo(),
                            const Text(
                              'Create an account',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextFormField(
                              controller: _viewmodel.nameController,
                              validator: _viewmodel.validateName,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                hintText: 'Enter your name',
                              ),
                            ),
                            TextFormField(
                              controller: _viewmodel.emailController,
                              validator: _viewmodel.validateEmail,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter your email',
                              ),
                            ),
                            TextFormField(
                              controller: _viewmodel.passwordController,
                              validator: _viewmodel.validatePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                suffixIcon: IconButton(
                                  padding: const EdgeInsetsDirectional.only(end: 8.0),
                                  onPressed: _viewmodel.switchPasswordVisibility, 
                                  icon: Icon(
                                    _viewmodel.passwordObscured
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  ),
                                )
                              ),
                              obscureText: _viewmodel.passwordObscured,
                            ),
                            TextFormField(
                              controller: _viewmodel.confirmPasswordController,
                              validator: _viewmodel.validateConfirmPassword,
                              decoration: const InputDecoration(
                                labelText: 'Confirm Password',
                                hintText: 'Confirm your password',
                              ),
                              obscureText: _viewmodel.passwordObscured,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () async { 
                                final success = await _viewmodel.register();
                                
                                await showDialog(
                                  // ignore: use_build_context_synchronously
                                  context: context, 
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(success ? 'Success' : 'Error'),
                                      content: Text(success ? 'Account created successfully' : 'Account creation failed'),
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
                                if (success) _viewmodel.navigateToEmailVerification(context);
                              },
                              child: const Text('Register'),
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Text('Already have an account?'),
                                TextButton(
                                  onPressed: () => _viewmodel.navigateToSignIn(context), 
                                  child: const Text('Sign in')
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ),
                ),
              )
            ),
          );
        }
      ),
    );
  }

}