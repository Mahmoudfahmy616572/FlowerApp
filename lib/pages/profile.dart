import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flower_app/shared/ImageUrl.dart';
import 'package:flower_app/shared/Snakbar.dart';
import 'package:flower_app/shared/colors.dart';
import 'package:flower_app/shared/getDataFromFirestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' show basename;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final credential = FirebaseAuth.instance.currentUser;
  final userss = FirebaseAuth.instance.currentUser!;
  CollectionReference users = FirebaseFirestore.instance.collection('userSSS');
  File? imgPath;
  String? imgName;

  uploadImage(ImageSource choosedPhoto) async {
    final pickedImg = await ImagePicker().pickImage(source: choosedPhoto);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imgName = "$random$imgName";
        });
      } else {
        showSnackBar(context, "NO img selected");
      }
    } catch (e) {
      showSnackBar(context, "Error => $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: bTNgreen,
          title: const Text(
            "profile",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          )),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey),
                      child: imgPath == null
                          ? const ImageUrl()
                          : ClipOval(
                              child: Image.file(
                                imgPath!,
                                width: 145,
                                height: 145,
                                fit: BoxFit.cover,
                              ),
                            )),
                  Positioned(
                      top: 100,
                      left: 100,
                      child: Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.green),
                        child: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: const EdgeInsets.all(22),
                                      color: Colors.blue[200],
                                      height: 120,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blue[500]),
                                            child: IconButton(
                                                onPressed: () async {
                                                  await uploadImage(
                                                      ImageSource.gallery);
                                                  if (imgPath != null) {
                                                    final storageRef =
                                                        FirebaseStorage.instance
                                                            .ref(imgName);
                                                    await storageRef
                                                        .putFile(imgPath!);
                                                    String url =
                                                        await storageRef
                                                            .getDownloadURL();
                                                    users
                                                        .doc(credential!.uid)
                                                        .update({
                                                      "imageLink": url,
                                                    });
                                                  }
                                                
                                                },
                                                icon: const Icon(
                                                    Icons.add_photo_alternate)),
                                          ),
                                          const SizedBox(
                                            width: 22,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blue[500]),
                                            child: IconButton(
                                                onPressed: () async {
                                                  await uploadImage(
                                                      ImageSource.camera);
                                                  if (imgPath != null) {
                                                    final storageRef =
                                                        FirebaseStorage.instance
                                                            .ref(imgName);
                                                    await storageRef
                                                        .putFile(imgPath!);

                                                    String url =
                                                        await storageRef
                                                            .getDownloadURL();
                                                    users
                                                        .doc(credential!.uid)
                                                        .update({
                                                      "imgURL": url,
                                                    });
                                                  }
                                                  Navigator.pop(context);
                                                },
                                                icon: const Icon(Icons
                                                    .add_a_photo_outlined)),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  isScrollControlled: true);
                            },
                            color: Colors.white,
                            icon: const Icon(Icons.add_a_photo_sharp)),
                      )),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(189, 59, 177, 186),
                  borderRadius: BorderRadius.circular(9)),
              child: const Text(
                "Info From firebase Auth",
                style: TextStyle(fontSize: 20),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        "Email :  ${credential!.email}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Created Date :    ${DateFormat("MMM d,y").format(credential!.metadata.creationTime!)}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Last SignIn :  ${DateFormat("MMM d,y").format(credential!.metadata.lastSignInTime!)}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Center(
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            users.doc(credential!.uid).delete();
                            credential!.delete();

                            Navigator.pop(context);
                          });
                        },
                        child: const Text(
                          "Delete User",
                          style: TextStyle(fontSize: 22, color: Colors.red),
                        )),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50, bottom: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(189, 59, 177, 186),
                  borderRadius: BorderRadius.circular(9)),
              child: const Text(
                "Info From firebase firestore",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: GetDataFromFireStore(documentId: credential!.uid),
            ),
          ],
        ),
      )),
    );
  }
}
