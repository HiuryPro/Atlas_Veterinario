import 'dart:typed_data';

import 'package:flutter/material.dart';

class FutureImageVet extends StatefulWidget {
  final Future<Uint8List?>? imageFuture;
  const FutureImageVet({super.key, required this.imageFuture});

  @override
  State<FutureImageVet> createState() => _FutureImageVetState();
}

class _FutureImageVetState extends State<FutureImageVet> {
  TransformationController controller = TransformationController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: widget.imageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 50,
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox();
        }
        return Center(
          child: Image.memory(snapshot.data!, fit: BoxFit.fill),
        );
      },
    );
  }
}
