import 'dart:convert';
import 'dart:math';

import 'package:atlas_veterinario/Proxy/proxyimagens.dart';
import 'package:atlas_veterinario/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';

class BuscaImagem extends StatefulWidget {
  const BuscaImagem({super.key});

  @override
  State<BuscaImagem> createState() => _BuscaImagemState();
}

const double min = pi * -2;
const double max = pi * 2;

const double minScale = 1;
const double defScale = 0.1;
const double maxScale = 4;

class _BuscaImagemState extends State<BuscaImagem> {
  late PhotoViewControllerBase controller;
  late PhotoViewScaleStateController scaleStateController;
  Uint8List? logoBase64;

  int calls = 0;

  @override
  void initState() {
    controller = PhotoViewController(initialScale: defScale)
      ..outputStateStream.listen(onController);

    scaleStateController = PhotoViewScaleStateController()
      ..outputScaleStateStream.listen(onScaleState);
    super.initState();
  }

  void onController(PhotoViewControllerValue value) {
    setState(() {
      calls += 1;
    });
  }

  void onScaleState(PhotoViewScaleState scaleState) {
    print(scaleState);
  }

  @override
  void dispose() {
    controller.dispose();
    scaleStateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExampleAppBarLayout(
      title: "Inline usage",
      showGoBack: true,
      child: ListView(
        children: <Widget>[
          const Text("Testar funções que busca Imagem"),
          const SizedBox(height: 15),
          ElevatedButton(
              onPressed: () async {
                Map imagem = {};
                ProxyImagens imagemProxy = ProxyImagens.instance;
                imagem = await imagemProxy.find(4);
                // print(imagem);
                imagem = await imagemProxy.find(4);

                String logobase64Str = imagem['Image'];
                logoBase64 = base64.decode(logobase64Str);
                controller.scale = imagem['Zoom'];
                print(imagem);
                setState(() {});

                setState(() {});
                // print(imagem);
              },
              child: const Text('Teste')),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: const Text(
              "Example of usage in a contained context",
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 20.0,
            ),
            height: 350.0,
            child: ClipRect(
              child: PhotoView(
                controller: controller,
                imageProvider: logoBase64 == null
                    ? AssetImage('assets/images/placeholder.png')
                        as ImageProvider
                    : MemoryImage(logoBase64!),
                maxScale: PhotoViewComputedScale.covered * 3.0,
                minScale: PhotoViewComputedScale.contained * 0.8,
                initialScale: PhotoViewComputedScale.covered,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
