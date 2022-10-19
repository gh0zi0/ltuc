import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ltuc/components/t_button.dart';

import 'bottom_sheet_post.dart';

// ignore: must_be_immutable
class ListTilePost extends StatelessWidget {
  ListTilePost({super.key, required this.list, required this.index});
  List<QueryDocumentSnapshot<Object?>>? list;
  int index;

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
                        .doc(list![index].id)
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
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: Key(list![index].id),
      confirmDismiss: (direction) => delete(context),
      background: Container(
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
      child: SizedBox(
        height: 200,
        width: double.infinity,
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text(list![index]['title']),
                Image.network(list![index]['image'].toString()),
                // Container(
                //   decoration: BoxDecoration(
                //       image: DecorationImage(
                //           image:
                //               NetworkImage(list![index]['image'].toString()))),
                // ),
                // if (list![index]['image'].toString().isNotEmpty)
                //   Hero(
                //     tag: list![index]['image'].toString(),
                //     child: GestureDetector(
                //         onTap: () => Navigator.pushNamed(
                //               context,
                //               '/fullScreen',
                //               arguments: {
                //                 'imageUrl': list![index]['image'].toString()
                //               },
                //             ),
                //         child: Container(
                //           decoration: BoxDecoration(
                //               image: DecorationImage(
                //                   image: NetworkImage(
                //                       list![index]['image'].toString()))),
                //         )),
                //   ),
                Text(list![index]['content'])
              ],
            )
            // ListTile(
            //   title: Text(list![index]['title']),
            //   subtitle: Text('${list![index]['content']} JOD'),
            //   leading: list![index]['image'].toString().isEmpty
            //       ? const Icon(Icons.photo)
            //       : Hero(
            //           tag: list![index]['image'].toString(),
            //           child: GestureDetector(
            //             onTap: () => Navigator.pushNamed(
            //               context,
            //               '/fullScreen',
            //               arguments: {
            //                 'imageUrl': list![index]['image'].toString()
            //               },
            //             ),
            //             child: CircleAvatar(
            //               backgroundImage:
            //                   NetworkImage(list![index]['image'].toString()),
            //             ),
            //           ),
            //         ),
            //   trailing: IconButton(
            //     icon: const Icon(Icons.edit),
            //     onPressed: () {
            //       showModalBottomSheet(
            //         context: context,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(20),
            //         ),
            //         backgroundColor: Colors.white,
            //         builder: (context) {
            //           return BottomSheetPost(data: list, index: index);
            //         },
            //       );
            //     },
            //   ),
            // )
            ),
      ),
    );
  }
}
