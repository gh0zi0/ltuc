import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ltuc/components/empty_lottie.dart';
import '../components/list_tile_post.dart';

// ignore: must_be_immutable
class PostScreen extends StatelessWidget {
  PostScreen({super.key, required this.user});
  bool user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        final postData = snapshot.data?.docs;
        if (snapshot.hasData) {
          if (postData!.isEmpty) {
            return const EmptyLottie();
          }
          return Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: postData.length,
              itemBuilder: (context, index) {
                return ListTilePost(
                  list: postData,
                  index: index,
                  user: user,
                );
              },
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
