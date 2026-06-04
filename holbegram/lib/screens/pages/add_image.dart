import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../widgets/bottom_nav.dart';
import 'methods/post_storage.dart';

class AddImage extends StatefulWidget {
  const AddImage({Key? key}) : super(key: key);

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  Uint8List? _image;
  final TextEditingController _captionController =
      TextEditingController();

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

  Future<void> postImage() async {
    final userProvider =
        Provider.of<UserProvider>(context, listen: false);

    final user = userProvider.getUser;

    if (user == null || _image == null) {
      return;
    }

    String res = await PostStorage().uploadPost(
      _captionController.text,
      user.uid,
      user.username,
      user.photoUrl,
      _image!,
    );

    if (!mounted) return;

    if (res == "Ok") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Post Uploaded"),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNav(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res),
        ),
      );
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          TextButton(
            onPressed: postImage,
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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

            const SizedBox(height: 20),

            TextField(
              controller: _captionController,
              decoration: const InputDecoration(
                hintText: 'Write a caption...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  iconSize: 40,
                  icon: const Icon(
                    Icons.camera_alt,
                  ),
                  onPressed: selectImageFromCamera,
                ),
                IconButton(
                  iconSize: 40,
                  icon: const Icon(
                    Icons.photo_library,
                  ),
                  onPressed: selectImageFromGallery,
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (_image != null)
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(20),
                  child: Image.memory(
                    _image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
