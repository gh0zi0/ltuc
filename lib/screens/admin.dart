import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ltuc/components/bottom_sheet_student.dart';
import 'package:ltuc/screens/post_screen.dart';
import 'package:ltuc/screens/student_screen.dart';
import '../components/bottom_sheet_post.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with TickerProviderStateMixin {
  late TabController tab;

  @override
  void initState() {
    super.initState();
    tab = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (tab.index == 0) {
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
              } else {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.white,
                  builder: (context) {
                    return BottomSheetStudent(
                      data: const [],
                      index: 0,
                    );
                  },
                );
              }
            },
            child: const Icon(
              Icons.add,
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.grey.shade900,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/newStudents');
                  },
                  icon: const Icon(Icons.notifications))
            ],
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
            bottom: TabBar(
              tabs: const [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.photo_album_sharp,
                  ),
                ),
                Icon(
                  Icons.person,
                )
              ],
              controller: tab,
            ),
          ),
          body: TabBarView(
            controller: tab,
            children: [
              PostScreen(
                user: false,
              ),
              const StudentScreen(),
            ],
          )),
    );
  }
}
