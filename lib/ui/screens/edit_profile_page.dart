// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app/blocs/user_bloc/user_bloc.dart';
import 'package:recipe_app/blocs/user_bloc/user_event.dart';
import 'package:recipe_app/utils/current_user.dart';
import 'package:user_repository/user_repository.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _profileImage;
  late final _nameController;
  late final _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.user.name.isNotEmpty ? widget.user.name : null,
    );
    _bioController = TextEditingController(
      text: widget.user.bio.isNotEmpty ? widget.user.bio : null,
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  width: 100,
                  clipBehavior: Clip.hardEdge,
                  child: _profileImage != null
                      ? Image.file(_profileImage!)
                      : widget.user.imageUrl != ""
                          ? CachedNetworkImage(
                              imageUrl: widget.user.imageUrl,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : CachedNetworkImage(
                              imageUrl: "https://verdantfox.com/static/images/avatars_default/av_blank.png",
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: _pickImage,
                    child: const CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Your full name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _bioController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Bio',
                hintText: 'Write a brief description of yourself',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Save profile logic
                final name = _nameController.text;
                final bio = _bioController.text;

                if (name.trim().isNotEmpty) {
                  BlocProvider.of<UserBloc>(context).add(
                    UpdateUserName(
                      newName: name,
                      userId: CurrentUser.currentUser!.localId!,
                    ),
                  );
                }
                if (bio.trim().isNotEmpty) {
                  BlocProvider.of<UserBloc>(context).add(
                    UpdateUserBio(
                      newBio: bio,
                      userId: CurrentUser.currentUser!.localId!,
                    ),
                  );
                }
                if (_profileImage != null) {
                  BlocProvider.of<UserBloc>(context).add(
                    UpdateUserPhoto(
                      image: _profileImage!,
                      userId: CurrentUser.currentUser!.localId!,
                    ),
                  );
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
