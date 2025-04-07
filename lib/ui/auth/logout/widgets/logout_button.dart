
import 'package:flutter/material.dart';
import 'package:notes/ui/auth/logout/logout_viewmodel.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    super.key,
    this.onLogout,
    this.icon,
    required this.viewmodel,
  });

  final VoidCallback? onLogout;
  final bool? icon;
  final LogoutViewmodel viewmodel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewmodel, 
      builder: (context, _) {
        return ElevatedButton(
          onPressed: () { 
            showDialog(
              context: context, 
              builder: (context) {
                return AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      }, 
                      child: const Text('Cancel')
                    ),
                    TextButton(
                      onPressed: () {
                        if (onLogout != null) onLogout!();
                        viewmodel.signOut();
                        Navigator.pop(context);
                      }, 
                      child: const Text('Logout')
                    ),
                  ],
                );
              }
            );
          }, 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Logout'),
              if (icon != null && icon!) ... {
                const Icon(Icons.logout_rounded)
              }
            ],
          )
        );
      }
    );
  }

}