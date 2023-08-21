import 'dart:convert';

import 'package:atlas_veterinario/CadImagem/geraimagem.dart';
import 'package:atlas_veterinario/Utils/app_controller.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'dart:ui' as ui;

import '../Utils/utils.dart';
import '../Proxy/proxyimagens.dart';

class BuscarImagemPainter extends StatefulWidget {
  final int id;
  const BuscarImagemPainter({Key? key, required this.id}) : super(key: key);

  @override
  BuscarImagemPainterState createState() => BuscarImagemPainterState();
}

class BuscarImagemPainterState extends State<BuscarImagemPainter> {
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

  var carouselController = CarouselController();

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
            rotation: rotation + listRotation[rotationImagem],
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black,
            ),
            locked: true)
      ]);
    }
  }

  Widget buildDefault(BuildContext context) {
    if (isLegendas) {
      return criaButoesLegenda();
    } else {
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Color(0xff386e41), width: 3))),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 5),
              child: Row(
                children: [
                  Expanded(
                      child: AutoSizeText(nomeImagem,
                          maxLines: 2,
                          minFontSize: 10,
                          style: const TextStyle(fontSize: 20))),
                  IconButton(
                      tooltip: 'Clique para rotacionar a imagem.',
                      onPressed: () {
                        setState(() {
                          incrementalRotation += 1;
                          if (incrementalRotation == 4) {
                            incrementalRotation = 0;
                          }
                        });
                        print(incrementalRotation);
                        controller.clearDrawables();
                        initBackground(widget.id, incrementalRotation);
                      },
                      icon: Icon(PhosphorIcons.fill.arrowClockwise)),
                ],
              ),
            ),
          ),
          Expanded(
              child: RotatedBox(
            quarterTurns: rotationImagem,
            child: FutureImageVet(
              imageFuture: imageFuture,
            ),
          )),
          if (legendas.isNotEmpty)
            Container(
                margin: const EdgeInsets.only(top: 5),
                decoration: const BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Color(0xff386e41), width: 3))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: testeDrop(),
                ))
        ],
      );
    }
  }

  Widget criaButoesLegenda() {
    return ListView(
      children: legendas
          .map((legenda) => Padding(
                padding: const EdgeInsets.only(bottom: 5, top: 5),
                child: ElevatedButton(
                    onPressed: () async {
                      if (old != null) {
                        destacaNumero(old!, Colors.black);
                      }
                      int index = legendas.indexOf(legenda);

                      destacaNumero(controller.drawables[index] as TextDrawable,
                          coresDestaque[index]);
                      old = controller.drawables[index] as TextDrawable;
                      setState(() {
                        isLegendas = false;
                      });
                    },
                    child: Text(legenda)),
              ))
          .toList(),
    );
  }

  destacaNumero(TextDrawable old, Color cor) {
    TextDrawable oldDrawable = old;

    TextDrawable newDrawable = oldDrawable.copyWith(
        text: oldDrawable.text, style: oldDrawable.style.copyWith(color: cor));

    controller.replaceDrawable(old, newDrawable);
    imageFuture = controller
        .renderImage(Size(width, height))
        .then<Uint8List?>((ui.Image image) => image.pngBytes);
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AutoSizeText(
          item,
          style: const TextStyle(
            fontSize: 20,
          ),
          maxLines: 2,
          minFontSize: 10,
        ),
      ));

  DropdownButton testeDrop() {
    return DropdownButton(
        focusColor: Colors.transparent,
        alignment: Alignment.center,
        isExpanded: true,
        hint: const Text('Escolha a Parte'),
        value: legendaAtual,
        items: legendas.map((String valor) => buildMenuItem(valor)).toList(),
        onChanged: (value) {
          if (old != null) {
            destacaNumero(old!, Colors.black);
          }

          if (value != "") {
            int index = legendas.indexOf(value) - 1;

            destacaNumero(controller.drawables[index] as TextDrawable,
                coresDestaque[index]);
            old = controller.drawables[index] as TextDrawable;
          }

          setState(() {
            isLegendas = false;
            legendaAtual = value;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return buildDefault(context);
  }
}
