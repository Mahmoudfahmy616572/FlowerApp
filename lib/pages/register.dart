import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flower_app/pages/login.dart';
import 'package:flower_app/shared/Snakbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show basename;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isVisibility = true;

  registeration() async {
    setState(() {
      isLoading = true;
    });
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Upload image to firebase storage
      final storageRef = FirebaseStorage.instance.ref(imageName);
      await storageRef.putFile(imgPath!);
      String imageUrl = await storageRef.getDownloadURL();

      CollectionReference users =
          FirebaseFirestore.instance.collection('userSSS');

      users
          .doc(credential.user!.uid)
          .set({
            'imageLink': imageUrl,
            'Name': usernameController.text,
            'age': ageController.text,
            "password": passwordController.text,
            "email": emailController.text
          })
          .then((value) => showSnackBar(context, "user added"))
          .catchError(
              (error) => showSnackBar(context, "Failed to merge data: $error"));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showSnackBar(context, "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, "The account already exists for that email.");
      } else {
        showSnackBar(context, "ERROR please Try Agin later.");
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  bool isPasswordChange = false;
  bool hasUppercase = false;
  bool hasDigits = false;
  bool hasLowercase = false;
  bool hasSpecialCharacters = false;
  onPasswordChange(String password) {
    setState(() {
      if (password.contains(RegExp(r'.{8,}'))) {
        isPasswordChange = true;
      }
      if (password.contains(RegExp(r'[A-Z]'))) {
        hasUppercase = true;
      }
      if (password.contains(RegExp(r'[A-Z]'))) {
        hasLowercase = true;
      }
      if (password.contains(RegExp(r'[0-9]'))) {
        hasDigits = true;
      }
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        hasSpecialCharacters = true;
      }
    });
  }

  File? imgPath;
  String? imageName;

  uploadImage(ImageSource choosedPhoto) async {
    final pickedImg = await ImagePicker().pickImage(source: choosedPhoto);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          imageName = basename(pickedImg.path);
          int random = Random().nextInt(9999999);
          imageName = "$random$imageName";
        });
      } else {
        showSnackBar(context, "NO img selected");
      }
    } catch (e) {
      showSnackBar(context, "Error => $e");
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/img/register.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 35,
                top: 100,
              ),
              child: const Text(
                'Create\nAccount',
                style: TextStyle(color: Colors.white, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: MediaQuery.of(context).size.height * 0.19),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.grey),
                                child: imgPath == null
                                    ? const CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        backgroundImage:
                                            AssetImage("assets/img/avatar.jpg"),
                                        radius: 70)
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
                                      shape: BoxShape.circle,
                                      color: Colors.green),
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
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              Colors.blue[500]),
                                                      child: IconButton(
                                                          onPressed: () {
                                                            uploadImage(
                                                                ImageSource
                                                                    .gallery);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          icon: const Icon(Icons
                                                              .add_photo_alternate)),
                                                    ),
                                                    const SizedBox(
                                                      width: 22,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              Colors.blue[500]),
                                                      child: IconButton(
                                                          onPressed: () async {
                                                            await uploadImage(
                                                                ImageSource
                                                                    .camera);
                                                            Navigator.pop(
                                                                context);
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
                      const SizedBox(
                        height: 64,
                      ),
                      TextFormField(
                        controller: usernameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(9)),
                          labelText: "UserName",
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(Icons.person),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(9)),
                        ),
                      ),
                      const SizedBox(
                        height: 33,
                      ),
                      TextFormField(
                        validator: (email) {
                          return email!.contains((RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")))
                              ? null
                              : "Enter a valid email";
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(9)),
                          labelText: "Email",
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(Icons.email),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(9)),
                        ),
                      ),
                      const SizedBox(
                        height: 33,
                      ),
                      TextFormField(
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(9)),
                          labelText: "Age",
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(Icons.quick_contacts_mail_outlined),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(9)),
                        ),
                      ),
                      const SizedBox(
                        height: 33,
                      ),
                      TextFormField(
                        onChanged: (password) {
                          onPasswordChange(password);
                        },
                        validator: (value) {
                          return value!.length < 8
                              ? "Enter at least 8 characters"
                              : null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: isVisibility ? true : false,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(9)),
                          labelText: "Password",
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: () {},
                              icon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isVisibility = !isVisibility;
                                    });
                                  },
                                  icon: isVisibility
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off))),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(9)),
                        ),
                      ),
                      const SizedBox(
                        height: 33,
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isPasswordChange
                                            ? Colors.green
                                            : Colors.white,
                                        border: Border.all(color: Colors.grey)),
                                    child: const Icon(
                                      Icons.check,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text("has Min8Characters")
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: hasUppercase
                                            ? Colors.green
                                            : Colors.white,
                                        border: Border.all(color: Colors.grey)),
                                    child: const Icon(
                                      Icons.check,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text("has Uppercase")
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: hasLowercase
                                            ? Colors.green
                                            : Colors.white,
                                        border: Border.all(color: Colors.grey)),
                                    child: const Icon(
                                      Icons.check,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text("has Lowercase")
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: hasDigits
                                            ? Colors.green
                                            : Colors.white,
                                        border: Border.all(color: Colors.grey)),
                                    child: const Icon(
                                      Icons.check,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text("Has Digits")
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: hasSpecialCharacters
                                            ? Colors.green
                                            : Colors.white,
                                        border: Border.all(color: Colors.grey)),
                                    child: const Icon(
                                      Icons.check,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text("Special Characters")
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.w700),
                          ),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color(0xff4c505b),
                            child: IconButton(
                                color: Colors.white,
                                onPressed: () async {
                                  if (_formKey.currentState!.validate() &&
                                      imgPath != null &&
                                      imageName != null) {
                                    await registeration();
                                    if (!mounted) return;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) => const Login())));
                                  } else {
                                    showSnackBar(context, "ERROR");
                                  }
                                },
                                icon: isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Icon(
                                        Icons.arrow_forward,
                                      )),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()),
                                  );
                                },
                                child: const Text('sign in',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.black54,
                                        fontSize: 18))),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
