import 'dart:convert';

import 'package:atlas_veterinario/CadImagem/geraimagem.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';

import 'dart:ui' as ui;

import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../Utils/utils.dart';
import '../Proxy/proxyimagens.dart';

class BuscarImagemPainter extends StatefulWidget {
  const BuscarImagemPainter({Key? key}) : super(key: key);

  @override
  BuscarImagemPainterState createState() => BuscarImagemPainterState();
}

class BuscarImagemPainterState extends State<BuscarImagemPainter> {
  ProxyImagens imagemProxy = ProxyImagens.instance;
  Future<Uint8List?>? imageFuture;
  Utils utils = Utils();
  double width = 100;
  double height = 100;

  late PainterController controller;
  ui.Image? backgroundImage;
  Paint shapePaint = Paint()
    ..strokeWidth = 5
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  @override
  void initState() {
    super.initState();
    controller = PainterController(
        settings: PainterSettings(
            text: const TextSettings(
              textStyle: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18),
            ),
            freeStyle: const FreeStyleSettings(
              color: Colors.red,
              strokeWidth: 5,
            ),
            shape: ShapeSettings(
              paint: shapePaint,
            ),
            scale: const ScaleSettings(
              enabled: true,
              minScale: 1,
              maxScale: 6,
            )));
    initBackground(21);
  }

  void initBackground(int id) async {
    Map resultados = await imagemProxy.find(id);
    Uint8List logoBase64 = base64.decode(resultados['Imagem']);

    final image = await MemoryImage(logoBase64).image;

    setState(() {
      backgroundImage = image;
      controller.background = image.backgroundDrawable;
    });

    width = resultados['Width'];
    height = resultados['Height'];

    setState(() {});

    adicionatexto(resultados);
    adicionaSeta(resultados);
    adicionaContorno(resultados);
    imageFuture = controller
        .renderImage(Size(width, height))
        .then<Uint8List?>((ui.Image image) => image.pngBytes);
    setState(() {});
  }

  adicionatexto(Map resultados) {
    for (Map imagemTexto in resultados['Imagem_Texto']) {
      String texto = imagemTexto['Texto'];
      int cor = imagemTexto['Cor'];
      double zoom = imagemTexto['Zoom'].runtimeType == int
          ? imagemTexto['Zoom'].toDouble()
          : imagemTexto['Zoom'];

      double dx = imagemTexto['Dx'].runtimeType == int
          ? imagemTexto['Dx'].toDouble()
          : imagemTexto['Dx'];

      double dy = imagemTexto['Dy'].runtimeType == int
          ? imagemTexto['Dy'].toDouble()
          : imagemTexto['Dy'];

      double fontSize = imagemTexto['FontSize'].toDouble();

      controller.addDrawables([
        TextDrawable(
            text: texto,
            position: Offset(dx, dy),
            scale: zoom,
            style: TextStyle(
                fontSize: fontSize,
                color: Color(cor),
                fontWeight: FontWeight.bold),
            locked: true)
      ]);
    }
  }

  adicionaSeta(Map resultados) {
    for (Map imagemSeta in resultados['Imagem_Seta']) {
      double traco = imagemSeta['Traco'].runtimeType == int
          ? imagemSeta['Traco'].toDouble()
          : imagemSeta['Traco'];

      Paint shapePaint = Paint()
        ..strokeWidth = traco
        ..color = Color(imagemSeta['Cor'])
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      double largura = imagemSeta['Largura'].runtimeType == int
          ? imagemSeta['Largura'].toDouble()
          : imagemSeta['Largura'];

      double rotation = imagemSeta['Rotacao'].runtimeType == int
          ? imagemSeta['Rotacao'].toDouble()
          : imagemSeta['Rotacao'];

      double zoom = imagemSeta['Zoom'].runtimeType == int
          ? imagemSeta['Zoom'].toDouble()
          : imagemSeta['Zoom'];

      double dx = imagemSeta['Dx'].runtimeType == int
          ? imagemSeta['Dx'].toDouble()
          : imagemSeta['Dx'];

      double dy = imagemSeta['Dy'].runtimeType == int
          ? imagemSeta['Dy'].toDouble()
          : imagemSeta['Dy'];

      controller.addDrawables([
        ArrowDrawable(
            paint: shapePaint,
            rotationAngle: rotation,
            length: largura,
            position: Offset(dx, dy),
            scale: zoom,
            locked: true)
      ]);
    }
  }

  adicionaContorno(Map resultados) {
    for (Map imagemContorno in resultados['Imagem_Contorno']) {
      double traco = imagemContorno['Traco'].runtimeType == int
          ? imagemContorno['Traco'].toDouble()
          : imagemContorno['Traco'];

      List<Offset> offsets =
          utils.parseStringDoubleListToOffsetList(imagemContorno['Path']);

      controller.addDrawables([
        FreeStyleDrawable(
            path: offsets,
            color: Color(imagemContorno['Cor']),
            strokeWidth: traco)
      ]);
    }
  }

  Widget buildDefault(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          // Listen to the controller and update the UI when it updates.
          child: ValueListenableBuilder<PainterControllerValue>(
              valueListenable: controller,
              child: Row(children: [
                const Text("Flutter Painter Example"),
                IconButton(
                    onPressed: () {
                      if (controller.drawables[0].runtimeType == TextDrawable) {
                        TextDrawable oldDrawable =
                            controller.drawables[0] as TextDrawable;

                        TextDrawable newDrawable = TextDrawable(
                            text: oldDrawable.text,
                            position: oldDrawable.position,
                            style: TextStyle(
                                color: const Color(0xffa00000),
                                fontSize: oldDrawable.style.fontSize,
                                fontWeight: oldDrawable.style.fontWeight),
                            scale: oldDrawable.scale);

                        controller.replaceDrawable(oldDrawable, newDrawable);
                        imageFuture = controller
                            .renderImage(Size(width, height))
                            .then<Uint8List?>(
                                (ui.Image image) => image.pngBytes);
                        setState(() {});
                      }
                      print(controller.drawables[0]);
                    },
                    icon: Icon(PhosphorIcons.fill.image))
              ]),
              builder: (context, _, child) {
                return AppBar(
                  title: child,
                );
              }),
        ),
        body: Stack(
          children: [
            if (backgroundImage != null)
              Column(
                children: [
                  Expanded(
                      child: Center(
                          child: FutureImageVet(imageFuture: imageFuture))),
                ],
              ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return buildDefault(context);
  }
}
