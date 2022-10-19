import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ltuc/components/list_tile_student.dart';

// ignore: must_be_immutable
class NewStudent extends StatelessWidget {
  const NewStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Students'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('students').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          final studentData = snapshot.data?.docs;
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: studentData!.length,
                itemBuilder: (context, index) {
                  return ListTileStudent(list: studentData, index: index,newS: true,);
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
