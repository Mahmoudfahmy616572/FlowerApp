// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/pages/login.dart';
import 'package:flower_app/shared/Snakbar.dart';
import 'package:flower_app/shared/colors.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  bool isLoading = false;

  resetPassword() async {
    isLoading = true;

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      if (!mounted) return;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));
    } catch (e) {
      showSnackBar(context, e.toString());
    }

    isLoading = false;
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: bTNgreen,
          title: const Text(
            "Reset Password",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
      body: Center(
          child: FractionallySizedBox(
        widthFactor: 0.9,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text(
                "Enter Your Email To Reset Password",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 40,
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
                  filled: true,
                  fillColor: const Color.fromARGB(255, 212, 212, 212),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: bTNgreen, width: 3),
                      borderRadius: BorderRadius.circular(9)),
                  labelText: "Email",
                  labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  prefixIcon: const Icon(Icons.email),
                  prefixIconColor: bTNgreen,
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(9)),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(bTNgreen),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22)))),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (!mounted) return;
                      resetPassword();
                    } else {
                      showSnackBar(context, "ERROR");
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Reset",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ))
            ]),
          ),
        ),
      )),
    );
  }
}
