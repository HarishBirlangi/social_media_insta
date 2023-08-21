import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_insta/models/user.dart';

class UploadPage extends StatefulWidget {
  final UserDetails gCurrentUser;
  const UploadPage({Key? key, required this.gCurrentUser}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  late XFile _file;
  TextEditingController descriptionTextEditingController =
      TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return _file == null ? displayUploadScreen() : displayUploadFormScreen();
  }

  Widget displayUploadScreen() {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add_photo_alternate,
            color: Colors.grey,
            size: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () => takeImage(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text(
                'Upload image',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          )
        ],
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: const Text(
            'New Post',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          children: [
            SimpleDialogOption(
              onPressed: captureImageWithCamera,
              child: const Text(
                'Capture with camera',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SimpleDialogOption(
              onPressed: pickImageFromGallery,
              child: const Text(
                'Select image from gallery',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void captureImageWithCamera() async {
    Navigator.pop(context);
    XFile? imageFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, maxHeight: 680, maxWidth: 970);
    if (imageFile != null) {
      setState(() {
        _file = imageFile;
      });
    }
  }

  void pickImageFromGallery() async {
    Navigator.pop(context);
    XFile? imageFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _file = imageFile;
      });
    }
  }

  displayUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New post',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Share',
              style: TextStyle(
                color: Colors.lightGreenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(File(_file.path)), fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(widget.gCurrentUser.url)),
            title: Container(
              width: 25,
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: descriptionTextEditingController,
                decoration: const InputDecoration(
                    hintText: "Say something about image",
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person_pin_circle,
                color: Colors.white, size: 36),
            title: Container(
              width: 25,
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: locationTextEditingController,
                decoration: const InputDecoration(
                    hintText: "Write the location here",
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none),
              ),
            ),
          ),
          Container(
            width: 220,
            height: 110,
            alignment: Alignment.center,
            // child:
            // ElevatedButton.icon(onPressed: () {}, icon: icon, label: label),
          )
        ],
      ),
    );
  }
}
