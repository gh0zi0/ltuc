import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../components/bottom_sheet_reset_password.dart';
import '../components/e_button.dart';
import '../components/edit_text.dart';
import '../components/t_button.dart';


class RegesterScreen extends StatefulWidget {
  const RegesterScreen({super.key});

  @override
  State<RegesterScreen> createState() => _RegesterScreenState();
}

class _RegesterScreenState extends State<RegesterScreen> {
  final GlobalKey<FormState> key = GlobalKey();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  var email = TextEditingController(),
      password = TextEditingController(),
      name = TextEditingController(),
      auth = FirebaseAuth.instance,
      store = FirebaseFirestore.instance,
      signIn = true,
      loading = false;

  changeState() {
    setState(() {
      signIn = !signIn;
    });
  }

  signInGoogle() async {
    try {
      setState(() {
        loading = true;
      });
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        setState(() {
          loading = false;
        });
        return null;
      }
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await auth.signInWithCredential(credential);

      await store
          .collection('students')
          .doc(auth.currentUser!.uid)
          .get()
          .then((value) async {
        if (value.exists) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Waiting admin to accept your request')));
        } else {
          await store
              .collection('users')
              .doc(auth.currentUser!.uid)
              .get()
              .then((value) async {
            if (value.exists) {
              Navigator.popAndPushNamed(context, '/home');
            } else {
              await store
                  .collection('students')
                  .doc(auth.currentUser!.uid)
                  .set({
                'name': googleSignInAccount.displayName,
                'user': true,
                'email': googleSignInAccount.email,
                'password': 'G'
              });
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Waiting admin to accept your request')));
            }
          });
        }
      });

      setState(() {
        loading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  forgetPass() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return const BottomSheetReset();
      },
    );
    try {} on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  authentication() async {
    if (!key.currentState!.validate()) {
      return;
    }
    setState(() {
      loading = true;
    });
    try {
      if (signIn) {
        await auth.signInWithEmailAndPassword(
            email: email.text, password: password.text);
        await store
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get()
            .then((value) {
          if (value['user']) {
            Navigator.popAndPushNamed(context, '/home');
          } else {
            Navigator.popAndPushNamed(context, '/admin');
          }
        });
      } else {
        await store.collection('students').add({
          'name': name.text,
          'user': true,
          'email': email.text,
          'password': password.text
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Waiting admin to accept your request')));
        setState(() {
          loading = false;
        });
        // ignore: use_build_context_synchronously

      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset(
                'images/logo.png',
                height: 150,
                width: 150,
              ),
              Text(
                signIn ? 'Sign In' : 'Sign Up',
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              EditTextFiled(
                hint: 'Email',
                icon: Icons.email,
                controller: email,
                secure: false,
                validator: (val) {
                  if (val!.isEmpty || !val.contains('@')) {
                    return 'Enter valid email';
                  }

                  return null;
                },
              ),
              EditTextFiled(
                hint: 'Password',
                secure: true,
                icon: Icons.password,
                controller: password,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Enter a password at least 6 characters';
                  }
                  return null;
                },
              ),
              if (signIn)
                Container(
                    padding: const EdgeInsets.only(right: 10),
                    alignment: Alignment.centerRight,
                    child: TButton(
                        title: 'Forget password?', function: forgetPass)),
              AnimatedOpacity(
                opacity: signIn ? 0 : 1,
                duration: const Duration(milliseconds: 500),
                child: EditTextFiled(
                  hint: 'Name',
                  secure: false,
                  icon: Icons.person,
                  controller: name,
                  validator: (val) {
                    if (val!.isEmpty && !signIn) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: signIn ? 50 : 75,
              ),
              TButton(
                  title: signIn
                      ? 'Don\'t have account? Sign Up'
                      : 'Already have account? Sign In',
                  function: changeState),
              loading
                  ? const CircularProgressIndicator()
                  : EButton(
                      title: signIn ? 'Sign In' : 'Sign Up',
                      function: authentication,
                    ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  children: const [
                    Expanded(
                        child: Divider(
                      thickness: 0.5,
                      color: Colors.black,
                    )),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('OR')),
                    Expanded(
                        child: Divider(
                      thickness: 0.5,
                      color: Colors.black,
                    )),
                  ],
                ),
              ),
              if (!loading)
                Container(
                  height: 75,
                  width: 75,
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () async {
                      signInGoogle();
                    },
                    child: Image.asset(
                      'images/g.png',
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
