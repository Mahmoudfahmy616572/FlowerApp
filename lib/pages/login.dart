import 'package:firebase_auth/firebase_auth.dart';
import 'package:flower_app/pages/forgetPassword.dart';
import 'package:flower_app/pages/home.dart';
import 'package:flower_app/pages/register.dart';
import 'package:flower_app/provider/googleSignIn.dart';
import 'package:flower_app/shared/Snakbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  bool isVisibility = true;
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  loginCode() async {
    setState(() {
      isLoading = true;
    });
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontroller.text,
        password: passwordcontroller.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(context, "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        showSnackBar(context, "Wrong password provided for that user.");
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final googleSignInProvider = Provider.of<GoogleSignInProvider>(context);

    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/img/login.png'), fit: BoxFit.cover),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Container(),
                Container(
                  padding: const EdgeInsets.only(left: 35, top: 130),
                  child: const Text(
                    'Welcome\n Back',
                    style: TextStyle(color: Colors.white, fontSize: 33),
                  ),
                ),
                const SizedBox(
                  height: 200,
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: MediaQuery.of(context).size.height * 0.4),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 64,
                          ),
                          TextFormField(
                            controller: emailcontroller,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 212, 212, 212),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(9)),
                              labelText: "Email",
                              labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 112, 112, 112),
                                  fontWeight: FontWeight.bold),
                              prefixIcon: const Icon(Icons.email),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.circular(9)),
                            ),
                          ),
                          const SizedBox(
                            height: 33,
                          ),
                          TextFormField(
                            controller: passwordcontroller,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: isVisibility ? true : false,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 212, 212, 212),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(9)),
                              labelText: "Password",
                              labelStyle: const TextStyle(
                                  color: Color.fromARGB(255, 112, 112, 112),
                                  fontWeight: FontWeight.bold),
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
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(9)),
                            ),
                          ),
                          const SizedBox(
                            height: 33,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Sign in',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 27,
                                    fontWeight: FontWeight.w700),
                              ),
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(0xff4c505b),
                                child: IconButton(
                                    color: Colors.white,
                                    onPressed: () async {
                                      await loginCode();
                                      if (!mounted) return;
                                      MaterialPageRoute(
                                        builder: (context) => const Home(),
                                      );
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
                          const SizedBox(
                            height: 33,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Register()),
                                    );
                                  },
                                  child: const Text('sign Up',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color:
                                              Color.fromARGB(255, 74, 72, 72),
                                          fontSize: 18))),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ForgetPassword()));
                                  },
                                  child: const Text('Forgot Password',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color:
                                              Color.fromARGB(255, 74, 72, 72),
                                          fontSize: 18))),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 299,
                            child: Row(
                              children: const [
                                Expanded(
                                    child: Divider(
                                  thickness: 0.9,
                                  color: Colors.black,
                                )),
                                Text(
                                  "OR",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                Expanded(
                                    child: Divider(
                                  thickness: 0.9,
                                  color: Colors.black,
                                )),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 27),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    googleSignInProvider.googlelogin();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            // color: Colors.red,
                                            width: 1)),
                                    child: SvgPicture.asset(
                                      "assets/icons/Google.svg",
                                      // color: Colors.purple[400],
                                      height: 27,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //
                        ]),
                  ),
                ),
              ],
            )));
  }
}
