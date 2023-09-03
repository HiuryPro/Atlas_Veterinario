import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';

import '../Proxy/proxyimagens.dart';
import '../Utils/utils.dart';
import 'geraimagem.dart';

class BuscarImagem extends StatefulWidget {
  final int id;
  const BuscarImagem({super.key, required this.id});

  @override
  State<BuscarImagem> createState() => _BuscarImagemState();
}

class _BuscarImagemState extends State<BuscarImagem> {
  ProxyImagens imagemProxy = ProxyImagens().getInterface();
  List<String> legendas = [""];
  List<Color> coresDestaque = [];
  String nomeImagem = '';
  TextDrawable? old;
  bool isLegendas = false;
  String legendaAtual = "";
  int rotationImagem = 1;
  int incrementalRotation = 0;

  Future<Uint8List?>? imageFuture;
  Utils utils = Utils();
  double width = 100;
  double height = 100;

  int indexAtivo = 0;
  bool enabled = false;
  List<double> listRotation = [
    0.0,
    4.71238898038469,
    3.141592653589793,
    1.5707963267948966
  ];
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
    initBackground(widget.id, 0);
  }

  void initBackground(int id, int rotation) async {
    Map resultados = await imagemProxy.find(id);
    Uint8List logoBase64 = base64.decode(resultados['Imagem']);

    final image = await MemoryImage(logoBase64).image;

    setState(() {
      backgroundImage = image;
      controller.background = image.backgroundDrawable;
    });

    width = resultados['Width'];
    height = resultados['Height'];
    rotationImagem = resultados['RotationImage'] + rotation;

    setState(() {
      adicionatexto(resultados);
    });

    imageFuture = controller
        .renderImage(Size(width, height))
        .then<Uint8List?>((ui.Image image) => image.pngBytes);
    setState(() {
      nomeImagem = resultados['NomeImagem'];
    });
  }

  adicionatexto(Map resultados) {
    for (Map imagemTexto in resultados['Imagem_Texto']) {
      legendas.add(imagemTexto['Legenda']);
      coresDestaque.add(Color(imagemTexto['CorDestaque']));

      String texto = imagemTexto['Numero'];

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
      double rotation = imagemTexto['Rotation'].toDouble();

      controller.addDrawables([
        TextDrawable(
            text: texto,
            position: Offset(dx, dy),
            scale: zoom,
            rotation: rotation,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black,
            ),
            locked: true)
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureImageVet(
      imageFuture: imageFuture,
    );
  }
}
