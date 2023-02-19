import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

class TesteFile extends StatefulWidget {
  const TesteFile({super.key});

  @override
  State<TesteFile> createState() => _TesteFileState();
}

class _TesteFileState extends State<TesteFile> {
  TextEditingController fileText = TextEditingController();
  String image = '1';
  Widget body() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: ListView(
              children: [
                TextField(
                  controller: fileText,
                  maxLines: 5,
                ),
                ElevatedButton(
                    onPressed: () async {
                      var file = await DefaultAssetBundle.of(context)
                          .load("assets/paginas/Teste.txt");
                      print(file.buffer.asUint8List());
                      print(base64Encode(file.buffer.asUint8List()));
                      var file2 = File(r'C:\Users\Hiury G\Downloads\t.txt')
                          .readAsBytes();
                      print(file2);

                      // pickImageFromGallery();
                    },
                    child: Text('Pega File')),
                if (image != '1')
                  Center(
                    child: Image.memory(
                      base64Decode(image),
                      height: 500,
                      width: 500,
                    ),
                  )
              ],
            )));
  }

  Future<String> documentPath() async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  pickImageFromGallery() {
    ImagePicker().pickImage(source: ImageSource.gallery).then((imgFile) async {
      String imgString = base64Encode(await imgFile!.readAsBytes());
      setState(() {
        image = imgString;
      });
      print(imgString);
      print(imgString);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }
}
