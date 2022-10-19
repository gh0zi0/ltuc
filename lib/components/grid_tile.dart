import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GridTileCustom extends StatefulWidget {
  GridTileCustom(
      {super.key,
      required this.index,
      required this.list,
      required this.function});

  int index;
  Function function;
  List<QueryDocumentSnapshot<Object?>>? list;

  @override
  State<GridTileCustom> createState() => _GridTileCustomState();
}

class _GridTileCustomState extends State<GridTileCustom> {
  @override
  Widget build(BuildContext context) {
    return GridTile(
        header: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          padding: const EdgeInsets.all(10),
          child: Text('${widget.list![widget.index]['price']} JOD'),
        ),
        footer: Container(
          decoration: const BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(widget.list![widget.index]['title']),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.add_shopping_cart,
                  color: Color.fromARGB(255, 110, 213, 194),
                ),
                onPressed: () async {
                  setState(() {});

                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product added to cart')));
                },
              ),
            ],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                  image: NetworkImage(widget.list![widget.index]['image']
                          .toString()
                          .isEmpty
                      ? 'https://www.nbmchealth.com/wp-content/uploads/2018/04/default-placeholder.png'
                      : widget.list![widget.index]['image'].toString())),
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          height: 100,
          width: 100,
        ));
  }
}
