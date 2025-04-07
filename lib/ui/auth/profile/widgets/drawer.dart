
import 'package:flutter/material.dart';
import 'package:notes/domain/model/user/user.dart';
import 'package:notes/ui/auth/login/login_viewmodel.dart';
import 'package:notes/ui/auth/login/widgets/login.dart';
import 'package:notes/ui/auth/logout/logout_viewmodel.dart';
import 'package:notes/ui/auth/logout/widgets/logout.dart';
import 'package:notes/ui/auth/profile/profile_viewmodel.dart';
import 'package:notes/ui/core/app_logo.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({
    super.key,
    this.elements,
    required ProfileViewmodel viewmodel,
  }) :
    _viewmodel = viewmodel;

  final List<Widget>? elements;
  final ProfileViewmodel _viewmodel;

  @override
  State<StatefulWidget> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  late Stream<User?> _user;

  @override
  void initState() {
    super.initState();
    _user = widget._viewmodel.userStream;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder(
        stream: _user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const DrawerHeader(
              child: Center(
                child: CircularProgressIndicator()
              ),
            );
          }
          if (snapshot.data != null) {
            User user = snapshot.data as User;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DrawerHeader(
                  child: ListView(
                    children: [
                      const Center(
                        child: AppLogo(),
                      ),
                      ListTile(
                        title: const Text('Profile'),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          child: ClipOval(
                            child: Transform.scale(
                              scale: 1.4,
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: user.photoUrl != null
                                  ? Image.network(
                                      user.photoUrl!,
                                      fit: BoxFit.fitHeight,
                                    )
                                  : Icon(
                                      Icons.person, 
                                      size: 30,
                                      color: Theme.of(context).colorScheme.onInverseSurface,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        onTap: () => widget._viewmodel.navigateToProfileDetails(context),
                      ),
                    ],
                  ),
                ),
                if (widget.elements != null) ...widget.elements!,
                // spacer
                const Expanded(child: SizedBox()),
                Logout(
                  icon: true,
                  viewmodel: LogoutViewmodel(
                    userRepository: context.read(),
                  ),
                ),
              ],
            );
          }
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: ListView(
                  children: [
                    const Center(
                      child: AppLogo(),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(
                              viewmodel: LoginViewmodel(
                                userRepository: context.read(),
                              ),
                            )
                          )
                        );
                      }, 
                      child: const Text('Sign in')
                    )
                  ],
                ),
              ),
              if (widget.elements != null) ...widget.elements!,
            ],
          );
        }
      ),
    );
  }
}