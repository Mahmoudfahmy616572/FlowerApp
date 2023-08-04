
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetDataFromFireStore extends StatefulWidget {
  final String documentId;

  const GetDataFromFireStore({super.key, required this.documentId});

  @override
  State<GetDataFromFireStore> createState() => _GetDataFromFireStoreState();
}

class _GetDataFromFireStoreState extends State<GetDataFromFireStore> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ageController = TextEditingController();
  final credential = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('userSSS');

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('userSSS');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("username :\n ${data['Name']}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                users
                                    .doc(credential!.uid)
                                    .update({"Name": FieldValue.delete()});
                              });
                            },
                            icon: const Icon(Icons.delete)),
                        const SizedBox(
                          width: 3,
                        ),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(11)),
                                    child: Container(
                                      padding: const EdgeInsets.all(22),
                                      height: 200,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextField(
                                              controller: nameController,
                                              maxLength: 25,
                                              decoration: const InputDecoration(
                                                  hintText: "Set Your Edit")),
                                          const SizedBox(
                                            height: 22,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      users
                                                          .doc(credential!.uid)
                                                          .update({
                                                        "Name":
                                                            nameController.text
                                                      });
                                                    });

                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Edite",
                                                    style:
                                                        TextStyle(fontSize: 22),
                                                  )),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Cancel",
                                                    style:
                                                        TextStyle(fontSize: 22),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.edit)),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("email:\n ${data['email']}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                users
                                    .doc(credential!.uid)
                                    .update({"email": FieldValue.delete()});
                              });
                            },
                            icon: const Icon(Icons.delete)),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(11)),
                                    child: Container(
                                      padding: const EdgeInsets.all(22),
                                      height: 200,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextField(
                                              controller: emailController,
                                              maxLength: 30,
                                              decoration: const InputDecoration(
                                                  hintText: "Set Your Edit")),
                                          const SizedBox(
                                            height: 22,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      users
                                                          .doc(credential!.uid)
                                                          .update({
                                                        "email":
                                                            emailController.text
                                                      });
                                                    });

                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Edite",
                                                    style:
                                                        TextStyle(fontSize: 22),
                                                  )),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Cancel",
                                                    style:
                                                        TextStyle(fontSize: 22),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.edit)),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("password:\n ${data['password']} ",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                users
                                    .doc(credential!.uid)
                                    .update({"password": FieldValue.delete()});
                              });
                            },
                            icon: const Icon(Icons.delete)),
                        const SizedBox(
                          width: 3,
                        ),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(11)),
                                    child: Container(
                                      padding: const EdgeInsets.all(22),
                                      height: 200,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextField(
                                              controller: passwordController,
                                              maxLength: 17,
                                              decoration: const InputDecoration(
                                                  hintText: "Set Your Edit")),
                                          const SizedBox(
                                            height: 22,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      users
                                                          .doc(credential!.uid)
                                                          .update({
                                                        "password":
                                                            passwordController
                                                                .text
                                                      });
                                                    });

                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Edite",
                                                    style:
                                                        TextStyle(fontSize: 22),
                                                  )),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Cancel",
                                                    style:
                                                        TextStyle(fontSize: 22),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.edit)),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "age:\n ${data['age']} Years old",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                users
                                    .doc(credential!.uid)
                                    .update({"age": FieldValue.delete()});
                              });
                            },
                            icon: const Icon(Icons.delete)),
                        const SizedBox(
                          width: 3,
                        ),
                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(11)),
                                    child: Container(
                                      padding: const EdgeInsets.all(22),
                                      height: 200,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextField(
                                              controller: ageController,
                                              maxLength: 2,
                                              decoration: const InputDecoration(
                                                  hintText: "Set Your Edit")),
                                          const SizedBox(
                                            height: 22,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      users
                                                          .doc(credential!.uid)
                                                          .update({
                                                        "age":
                                                            ageController.text
                                                      });
                                                    });

                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Edite",
                                                    style:
                                                        TextStyle(fontSize: 22),
                                                  )),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    "Cancel",
                                                    style:
                                                        TextStyle(fontSize: 22),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.edit)),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          users.doc(credential!.uid).delete();
                        });
                      },
                      child: const Text(
                        "Delete Data  ",
                        style: TextStyle(fontSize: 22, color: Colors.red),
                      )),
                )
              ]);
        }

        return const Text("loading");
      },
    );
  }
}
