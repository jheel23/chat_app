import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class USerImageProfile extends StatefulWidget {
  final void Function(File storeImage) imagePickFn;
  USerImageProfile(this.imagePickFn);
  @override
  State<USerImageProfile> createState() => _USerImageProfileState();
}

class _USerImageProfileState extends State<USerImageProfile> {
  File? _pickedImage;
  Future<void> _takeImage() async {
    final picker = ImagePicker();
    final pickedImageFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _pickedImage = File(pickedImageFile!.path);
    });
    widget.imagePickFn(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          maxRadius: 45,
          foregroundImage: _pickedImage != null
              ? FileImage(_pickedImage!)
              : AssetImage('lib/assets/images/dummyProfilePic.png')
                  as ImageProvider,
        ),
        const SizedBox(height: 20),
        TextButton.icon(
          icon: Icon(Icons.camera_alt_outlined),
          onPressed: _takeImage,
          label: Text('Take Profile Picture'),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
