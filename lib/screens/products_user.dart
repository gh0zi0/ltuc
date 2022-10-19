import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/grid_tile.dart';


// ignore: must_be_immutable
class ProductsUser extends StatefulWidget {
  ProductsUser({super.key, required this.function});
  Function function;

  @override
  State<ProductsUser> createState() => _ProductsUserState();
}

class _ProductsUserState extends State<ProductsUser> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        final productData = snapshot.data?.docs;
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: productData!.length,
              itemBuilder: (context, index) {
                return GridTileCustom(list: productData, index: index,function:widget.function);
              },
            ),
          );
        }
        return const Center(
            child: CircularProgressIndicator(
                color: Color.fromARGB(255, 110, 213, 194)));
      },
    );
  }
}
