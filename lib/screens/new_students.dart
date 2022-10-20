import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ltuc/components/list_tile_student.dart';
import '../components/empty_lottie.dart';

// ignore: must_be_immutable
class NewStudent extends StatelessWidget {
  const NewStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: const Text('New Students'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('students').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          final studentData = snapshot.data?.docs;
          if (snapshot.hasData) {
            if (studentData!.isEmpty) {
              return const EmptyLottie();
            }
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: studentData.length,
                itemBuilder: (context, index) {
                  return ListTileStudent(
                    list: studentData,
                    index: index,
                    newS: true,
                  );
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
