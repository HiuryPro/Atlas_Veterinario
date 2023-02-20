import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

import 'app_controller.dart';

class TesteFile extends StatefulWidget {
  const TesteFile({super.key});

  @override
  State<TesteFile> createState() => _TesteFileState();
}

class _TesteFileState extends State<TesteFile> {
  final GlobalKey<ScaffoldState> _keyS = GlobalKey();
  TextEditingController fileText = TextEditingController();
  String image = '1';
  double tamanhoFonte = 12;

  Widget body() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                    child: const Text('Pega File')),
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
      key: _keyS,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              iconSize: 48,
              tooltip: 'Abre opções do Aplicativo',
              onPressed: () => _keyS.currentState!.openDrawer(),
              icon: Image.asset('assets/images/unipam.png')),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  prefixIcon: Icon(Icons.search)),
            ),
          ),
          PopupMenuButton(
              iconSize: 48,
              tooltip: "Abre opções de Texto",
              icon: const Icon(Icons.menu, color: Colors.grey),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(child: StatefulBuilder(
                      builder: ((context, setState) {
                        return Column(children: [
                          const Text('Tamanho da fonte'),
                          Center(
                              child: Slider(
                            value: tamanhoFonte,
                            min: 9,
                            max: 100,
                            onChanged: ((newTF) {
                              this.setState(() {
                                tamanhoFonte = newTF;
                              });
                              setState(() {
                                tamanhoFonte = newTF;
                              });
                            }),
                          )),
                          const SizedBox(
                            height: 5,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Modo Noturno'),
                                Switch(
                                    value: AppController.instance.isDarkTheme,
                                    onChanged: ((value) {
                                      setState(() {
                                        AppController.instance.changeTheme();
                                      });
                                      // ignore: unnecessary_this
                                      this.setState(() {});
                                    }))
                              ],
                            ),
                          )
                        ]);
                      }),
                    )),
                  ]),
        ],
      ),
      body: body(),
    );
  }
}
