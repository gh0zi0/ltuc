import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ltuc/components/post_container.dart';
import 'package:ltuc/components/t_button.dart';
import 'bottom_sheet_post.dart';

// ignore: must_be_immutable
class ListTilePost extends StatefulWidget {
  ListTilePost(
      {super.key, required this.list, required this.index, required this.user});
  List<QueryDocumentSnapshot<Object?>>? list;
  int index;
  bool user;

  @override
  State<ListTilePost> createState() => _ListTilePostState();
}

class _ListTilePostState extends State<ListTilePost> {
  var doubleTap = false;
  delete(context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete the post?'),
          actions: [
            TButton(
                title: 'Yes',
                function: () async {
                  try {
                    await FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.list![widget.index].id)
                        .delete();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('post deleted')));
                  } on FirebaseException catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }),
            TButton(
                title: 'No',
                function: () {
                  Navigator.pop(context);
                })
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.user
        ? Stack(
            children: [
              GestureDetector(
                onDoubleTap: (() async {
                  setState(() {
                    doubleTap = true;
                  });
                  await Future.delayed(Duration(milliseconds: 1000));
                  setState(() {
                    doubleTap = false;
                  });
                }),
                child: PostContainer(
                  index: widget.index,
                  list: widget.list,
                ),
              ),
              if (doubleTap)
                Center(child: Lottie.asset('lottie/heart.json', height: 200)),
            ],
          )
        : Dismissible(
            key: Key(widget.list![widget.index].id),
            background: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Colors.green.shade300,
              ),
              padding: const EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              child: const Icon(
                Icons.edit,
              ),
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                delete(context);
              } else {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.white,
                  builder: (context) {
                    return BottomSheetPost(
                        data: widget.list, index: widget.index);
                  },
                );
              }
              return null;
            },
            secondaryBackground: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Colors.red.shade300,
              ),
              padding: const EdgeInsets.only(right: 20),
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.delete,
              ),
            ),
            child: PostContainer(
              index: widget.index,
              list: widget.list,
            ));
  }
}
