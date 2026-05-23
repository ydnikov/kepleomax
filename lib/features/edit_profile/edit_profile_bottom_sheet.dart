import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kepleomax/core/flavor.dart';
import 'package:kepleomax/core/models/user_profile.dart';
import 'package:kepleomax/core/presentation/colors.dart';
import 'package:kepleomax/core/extensions/build_context_extensions.dart';
import 'package:kepleomax/core/presentation/klm_cached_image.dart';
import 'package:kepleomax/core/presentation/klm_textfield.dart';
import 'package:kepleomax/core/presentation/user_image_widget.dart';
import 'package:kepleomax/core/presentation/validators.dart';

const String? Function(String) _usernameValidator = UiValidator.emptyValidator;

class EditProfileBottomSheet extends StatefulWidget {
  const EditProfileBottomSheet({
    required this.profile,
    required this.onSave,
    this.canClose = true,
    super.key,
  });

  final UserProfile profile;
  final ValueChanged<UserProfile> onSave;
  final bool canClose;

  @override
  State<EditProfileBottomSheet> createState() => _EditProfileBottomSheetState();
}

class _EditProfileBottomSheetState extends State<EditProfileBottomSheet> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isClosing = false;
  bool _isButtonPressed = false;
  bool _isImageEdited = false;
  String? _imageUrl;

  /// callbacks
  @override
  void initState() {
    final user = widget.profile.user;
    _imageUrl = user.profileImage;
    _nameController.text = user.username;
    _descriptionController.text = widget.profile.description;
    super.initState();
  }

  /// build
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.canClose)
                  _Button(
                    text: 'Cancel',
                    onPressed: _isClosing
                        ? null
                        : () {
                            Navigator.of(context).pop();
                          },
                  )
                else
                  const SizedBox(width: 55),
                Stack(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 26,
                        vertical: 4,
                      ),
                      child: ClipOval(
                        child: _imageUrl == null || _imageUrl!.isEmpty
                            ? const DefaultUserIconWidget()
                            : _isImageEdited
                            ? Image.file(File(_imageUrl!), fit: BoxFit.cover)
                            : KlmCachedImage(
                                imageUrl: flavor.imageUrl + _imageUrl!,
                                width: context.imageMaxWidth,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton.filled(
                        onPressed: _isClosing ? null : _editImage,
                        icon: const Icon(Icons.edit),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.all(5),
                          minimumSize: Size.zero,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton.filled(
                        onPressed: _isClosing ? null : _removeImage,
                        icon: const Icon(Icons.close, fontWeight: FontWeight.w600),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.red.shade600,
                          padding: const EdgeInsets.all(5),
                          minimumSize: Size.zero,
                        ),
                      ),
                    ),
                  ],
                ),
                _Button(
                  text: 'Save',
                  fontWeight: FontWeight.w600,
                  onPressed: _isClosing
                      ? null
                      : () {
                          setState(() {
                            _isButtonPressed = true;
                          });

                          if (_usernameValidator(_nameController.text) != null) {
                            return;
                          }

                          setState(() {
                            _isClosing = true;
                          });
                          final oldProfile = widget.profile;
                          final newProfile = oldProfile.copyWith(
                            description: _descriptionController.text.trim(),
                            user: oldProfile.user.copyWith(
                              username: _nameController.text.trim(),
                              profileImage: _isImageEdited
                                  ? _imageUrl
                                  : oldProfile.user.profileImage,
                            ),
                          );
                          widget.onSave(newProfile);
                          Navigator.of(context).pop();
                        },
                ),
              ],
            ),
            const SizedBox(height: 26),
            KlmTextField(
              controller: _nameController,
              label: 'Username',
              onChanged: (newName) {},
              readOnly: _isClosing,
              maxLength: 20,
              showErrors: _isButtonPressed,
              validators: const [_usernameValidator],
            ),
            const SizedBox(height: 20),
            KlmTextField(
              controller: _descriptionController,
              multiline: true,
              maxLength: 200,
              label: 'Description',
              onChanged: (newName) {},
              showErrors: _isButtonPressed,
              readOnly: _isClosing,
            ),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }

  /// actions
  Future<void> _removeImage() async {
    setState(() {
      _imageUrl = null;
      _isImageEdited = true;
    });
  }

  Future<void> _editImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image != null) {
      setState(() {
        _imageUrl = image.path;
        _isImageEdited = true;
      });
    }
  }
}

/// widgets
class _Button extends StatelessWidget {
  const _Button({
    required this.text,
    required this.onPressed,
    this.fontWeight = FontWeight.w500,
  });

  final String text;
  final VoidCallback? onPressed;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: context.textTheme.bodyLarge?.copyWith(
          color: KlmColors.primaryColor.shade800,
          fontWeight: fontWeight,
        ),
        textScaler: const TextScaler.linear(1),
      ),
    );
  }
}
