import 'package:flutter/material.dart';

class FullScreen extends StatelessWidget {
  const FullScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(),
      body: Hero(
        tag: arguments['imageUrl'],
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(arguments['imageUrl']))),
        ),
      ),
    );
  }
}
