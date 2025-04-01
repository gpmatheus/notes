
import 'package:flutter/material.dart';
import 'package:notes/ui/auth/account_verification/account_verification_viewmodel.dart';
import 'package:notes/ui/core/app_logo.dart';
import 'package:notes/ui/core/loading_screen.dart';

class AccountVerification extends StatefulWidget {
  const AccountVerification({
    super.key,
    required this.viewmodel,
  });

  final AccountVerificationViewmodel viewmodel;

  @override
  State<StatefulWidget> createState() => _AccountVerificationState();
}

class _AccountVerificationState extends State<AccountVerification> {

  @override
  void initState() {
    super.initState();

    widget.viewmodel.sendVerification.then((_) {
      if (mounted) widget.viewmodel.navigateToRoot(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () { }, 
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.viewmodel, 
        builder: (context, _) {
          return LoadingScreen(
            loading: widget.viewmodel.loading,
            screen: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: FutureBuilder(
                        future: widget.viewmodel.user,
                        builder: (context, snapshot) {
                          return Column(
                            children: [
                              const AppLogo(),
                              if (snapshot.hasData && snapshot.data != null) ... {
                                RichText(
                                  text: TextSpan(
                                    text: 'A verification link was sent to this email: ',
                                    style: DefaultTextStyle.of(context).style,
                                    children: [
                                      TextSpan(
                                        text: snapshot.data!.email,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ]
                                  ),
                                ),
                              },
                              const SizedBox(height: 30.0),
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  const Text('Haven\'t recieved the email yet?'),
                                  TextButton(
                                    onPressed: () { }, 
                                    child: const Text('Send email again')
                                  )
                                ],
                              )
                            ],
                          );
                        }
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
  
}