import 'dart:convert';
import 'dart:math';

import 'package:atlas_veterinario/Proxy/proxyimagens.dart';
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
const double defScale = 1;
const double maxScale = 4;

class _BuscaImagemState extends State<BuscaImagem> {
  late PhotoViewControllerBase controller;
  late PhotoViewScaleStateController scaleStateController;
  ProxyImagens imagemProxy = ProxyImagens.instance;

  ImageProvider imagemMembroAnimal =
      const AssetImage('assets/images/placeholder.png');
  Offset posicaoImagem = const Offset(20, 20);
  Map imagemDb = {};
  Uint8List? logoBase64;
  dynamic escala = PhotoViewComputedScale.contained;

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

  Widget body() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView(
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/salvaImagem');
                  },
                  child: const Text('Tela de buscar Imagem')),
              const SizedBox(
                height: 10,
              ),
              const Text("Testar funções que busca Imagem"),
              const SizedBox(height: 15),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      imagemDb = await imagemProxy.find(6);

                      print(imagemDb['Dx']);
                      print(imagemDb['Dy']);
                      String logobase64Str = imagemDb['Image'];
                      logoBase64 = base64.decode(logobase64Str);
                      imagemMembroAnimal = MemoryImage(logoBase64!);
                      posicaoImagem = Offset(imagemDb['Dx'], imagemDb['Dy']);

                      atualizaPosition();
                      print(imagemDb['Zoom']);
                      print(controller.scale);

                      print(controller.position);
                      print(posicaoImagem);
                    } catch (exception) {
                      print(exception);
                    }

                    // print(imagem);
                  },
                  child: const Text('Teste')),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 20.0,
                ),
                height: 350.0,
                child: logoBase64 == null
                    ? Container(
                        color: const Color(0xFFfafafa),
                      )
                    : ClipRect(
                        child: PhotoView(
                          gaplessPlayback: true,
                          disableGestures: true,
                          controller: controller,
                          imageProvider: imagemMembroAnimal,
                          maxScale: PhotoViewComputedScale.covered * 7.0,
                          minScale: PhotoViewComputedScale.contained * 0.8,
                          initialScale: PhotoViewComputedScale.contained,
                        ),
                      ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: body());
  }

  atualizaPosition() {
    setState(() {
      controller.scale = imagemDb['Zoom'];
      controller.position = posicaoImagem;
    });
  }
}
