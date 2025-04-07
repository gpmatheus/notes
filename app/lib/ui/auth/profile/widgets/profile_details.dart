
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/ui/auth/logout/logout_viewmodel.dart';
import 'package:notes/ui/auth/logout/widgets/logout_button.dart';
import 'package:notes/ui/auth/profile/profile_viewmodel.dart';
import 'package:notes/ui/core/loading_screen.dart';
import 'package:provider/provider.dart';

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

  bool _editingName = false;
  bool _loadingNameEditing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _editingName = false;
        });
      },
      child: Scaffold(
        appBar: AppBar(),
        body: ListenableBuilder(
          listenable: widget.viewmodel,
          builder: (context, _) {
            final user = widget.viewmodel.user;
            return LoadingScreen(
            loading: widget.viewmodel.loading,
            screen: user == null
              ? Center(
                child: Text(
                  'User not found',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.grey,
                                child: ClipOval(
                                  child: Transform.scale(
                                    scale: 1.4,
                                    child: SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: user.photoUrl != null
                                        ? Image.network(
                                            user.photoUrl!,
                                            fit: BoxFit.fitHeight,
                                          )
                                        : Icon(
                                            Icons.person_rounded, 
                                            size: 60,
                                            color: Theme.of(context).colorScheme.onInverseSurface,
                                          ),
                                    ),
                                  ),
                                )
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: _pickImage, 
                                    icon: Icon(
                                      Icons.edit_rounded,
                                      color: Theme.of(context).colorScheme.surface,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          user.name != null ? user.name! : '',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(user.email != null ? user.email! : ''),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!user.verified) ... [
                            Text(
                              'You are not verified',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => widget.viewmodel.navigateToEmailVerification(context), 
                              child: const Text('Verify email')
                            )
                          ] else ... [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: widget.viewmodel.nameController,
                                    enabled: _editingName,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                      label: Text('Name'),
                                    ),
                                  ),
                                ),
                                if (_loadingNameEditing) ... [
                                  const SizedBox(
                                    width: 45,
                                    height: 45,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                                ]
                                else if (!_editingName) ... [
                                  IconButton(
                                    icon: const Icon(Icons.edit_rounded),
                                    onPressed: () { 
                                      setState(() {
                                        _editingName = true;
                                      });
                                    },
                                  ),
                                ] else ... [
                                  IconButton(
                                    icon: const Icon(Icons.send_rounded),
                                    onPressed: () async {
                                      setState(() {
                                        _loadingNameEditing = true;
                                        _editingName = false;
                                      });
                                      await widget.viewmodel.updateName();
                                      setState(() {
                                        _loadingNameEditing = false;
                                      });
                                    },
                                  ),
                                ]
                              ],
                            ),
                            const SizedBox(height: 30),
                            Center(
                              child: LogoutButton(
                                viewmodel: LogoutViewmodel(
                                  userRepository: context.read(),
                                )
                              ),
                            )
                          ]
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      File? croppedImage = await _cropImage(File(pickedImage.path));
      setState(() {
        widget.viewmodel.imageFile = croppedImage;
      });
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 15, ratioY: 15),
      uiSettings: [
        AndroidUiSettings(
          cropStyle: CropStyle.circle,
          toolbarTitle: 'Place the image',
          hideBottomControls: true,
        )
      ],
    );
    if (croppedFile != null) {
      return File(croppedFile.path);
    }
    return null;
  }
  
}