import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ltuc/screens/post_screen.dart';
import '../components/bottom_sheet_post.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.white,
              builder: (context) {
                return BottomSheetPost(
                  data: const [],
                  index: 0,
                );
              },
            );
          },
          child: const Icon(
            Icons.add,
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Admin',
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.power_settings_new,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.popAndPushNamed(context, '/register');
            },
          ),
        ),body: const PostScreen(),);
  }
}
