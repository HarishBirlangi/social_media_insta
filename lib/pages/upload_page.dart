import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as imd;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_media_insta/models/user.dart';
import 'package:social_media_insta/pages/home_page.dart';
import 'package:uuid/uuid.dart';

class UploadPage extends StatefulWidget {
  final UserDetails gCurrentUser;
  const UploadPage({Key? key, required this.gCurrentUser}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  XFile? _file;
  TextEditingController descriptionTextEditingController =
      TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();
  bool uploading = false;
  String postId = const Uuid().v4();
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
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            clearPostInfo();
            // Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: uploading
                ? null
                : () {
                    controlUploadAndSave();
                  },
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
          uploading ? const LinearProgressIndicator() : const Text(''),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: FileImage(File(_file!.path)), fit: BoxFit.cover),
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
            child: ElevatedButton.icon(
              onPressed: getUserCurrentLocation,
              icon: const Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              label: const Text(
                "Get my current location",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          )
        ],
      ),
    );
  }

  Future<void> getLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  Future<void> getUserCurrentLocation() async {
    await getLocationPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placeMarks = await GeocodingPlatform.instance
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark mPlaceMark = placeMarks[0];
    String completeAddress =
        '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare} ${mPlaceMark.subLocality} ${mPlaceMark.locality} ${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea} ${mPlaceMark.postalCode} ${mPlaceMark.country}';
    String specificAddress = '${mPlaceMark.locality}, ${mPlaceMark.country}';
    locationTextEditingController.text = specificAddress;
  }

  compressPhoto() async {
    final tempDirectory = await getTemporaryDirectory();
    final path = tempDirectory.path;
    print('compress photo 1');
    imd.Image? mImageFile = imd.decodeImage(await _file!.readAsBytes());
    print('compress photo 2');
    File compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(imd.encodeJpg(mImageFile!, quality: 90));

    print('compress photo 3');

    setState(() {
      _file = XFile(compressedImageFile.path);
    });
  }

  void controlUploadAndSave() async {
    setState(() {
      uploading = true;
    });

    await compressPhoto();

    String downloadUrl = await uploadPhoto(_file);
    savePostsInfoToFireStore(
      url: downloadUrl,
      location: locationTextEditingController.text,
      description: descriptionTextEditingController.text,
    );
    locationTextEditingController.clear();
    descriptionTextEditingController.clear();
    setState(() {
      _file = null;
      uploading = false;
      postId = const Uuid().v4();
    });
  }

  Future<String> uploadPhoto(mImageFile) async {
    UploadTask mStorageUploadTask = postPicturesStorageReference
        .child('post_$postId.jgp')
        .putFile(File(mImageFile.path));
    TaskSnapshot storageTaskSnapshot =
        await mStorageUploadTask.whenComplete(() => null);
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  clearPostInfo() {
    descriptionTextEditingController.clear();
    locationTextEditingController.clear();
    setState(() {
      _file = null;
    });
  }

  @override
  bool get wantKeepAlive => true;

  void savePostsInfoToFireStore(
      {required String url,
      required String location,
      required String description}) {
    postDataReference
        .doc(widget.gCurrentUser.id)
        .collection('usersPosts')
        .doc(postId)
        .set({
      "postId": postId,
      "ownerId": widget.gCurrentUser.id,
      "timestamp": DateTime.timestamp(),
      "likes": {},
      "userName": widget.gCurrentUser.userName,
      "description": description,
      "location": location,
      "url": url,
    });
  }
}
