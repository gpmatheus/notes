
import 'package:flutter/material.dart';
import 'package:notes/domain/model/user/user.dart';
import 'package:notes/ui/auth/profile/profile_viewmodel.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({
    super.key,
    required this.viewmodel,
  });

  final ProfileViewmodel viewmodel;

  @override
  State<StatefulWidget> createState() => _ProfileDetailsState();

}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: widget.viewmodel.user, 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator()
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            final User user = snapshot.data!;
            return Center(
              child: user.verified
                ? const Text('user verified')
                : const Text('user not verified'),
            );
          }
          return const Text('Somethig went wrong');
        }
      ),
    );
  }
  
}