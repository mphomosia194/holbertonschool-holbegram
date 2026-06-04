import 'dart:typed_data';
import 'methods/auth_methods.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AddPicture({
    Key? key,
    required this.email,
    required this.password,
    required this.username,
  }) : super(key: key);

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  Uint8List? _image;

  void selectImageFromGallery() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final bytes = await image.readAsBytes();

      setState(() {
        _image = bytes;
      });
    }
  }

  void selectImageFromCamera() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image =
        await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final bytes = await image.readAsBytes();

      setState(() {
        _image = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
final String email = widget.email;
final String username = widget.username;
final String password = widget.password;
    return Scaffold(
      appBar: AppBar(
        title: const Text('username'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage:
                  _image != null ? MemoryImage(_image!) : null,
              child: _image == null
                  ? const Icon(
                      Icons.person,
                      size: 80,
                    )
                  : null,
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.camera_alt),
                  onPressed: selectImageFromCamera,
                ),

                const SizedBox(width: 30),

                IconButton(
                  iconSize: 40,
                  icon: const Icon(Icons.photo_library),
                  onPressed: selectImageFromGallery,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
