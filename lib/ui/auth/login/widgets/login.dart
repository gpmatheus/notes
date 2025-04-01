
import 'package:flutter/material.dart';
import 'package:notes/ui/auth/login/login_viewmodel.dart';
import 'package:notes/ui/auth/login/widgets/login_with_email.dart';
import 'package:notes/ui/auth/register/register_viewmodel.dart';
import 'package:notes/ui/auth/register/widgets/register.dart';
import 'package:notes/ui/core/app_logo.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({
    super.key,
    required this.viewmodel,
  });

  final LoginViewmodel viewmodel;

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
      ),
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppLogo(),
              SignInButtonBuilder(
                text: 'Sign in with Email',
                icon: Icons.email,
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => LoginWithEmail(
                        viewmodel: LoginViewmodel(
                          userRepository: context.read(),
                        ),
                      )
                    )
                  );
                },
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                textColor: Theme.of(context).colorScheme.onSurface,
                width: 220.0,
              ),
              SignInButton(
                Buttons.google, 
                onPressed: () async { 
                  final bool success = await widget.viewmodel.signInWithGoogle();
                  // ignore: use_build_context_synchronously
                  if (success && mounted) widget.viewmodel.navigateToRoot(context);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () { 
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => Register(
                            viewmodel: RegisterViewmodel(
                              userRepository: context.read(),
                            ),
                          )
                        )
                      );
                    }, 
                    child: const Text('Create one'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  
}