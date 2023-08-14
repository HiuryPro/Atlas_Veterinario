import 'dart:convert';

import 'package:atlas_veterinario/CadImagem/geraimagem.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';

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
  TextDrawable? old;
  bool isLegendas = false;
  String legendaAtual = "";

  Future<Uint8List?>? imageFuture;
  Utils utils = Utils();
  double width = 100;
  double height = 100;

  var carouselController = CarouselController();

  int indexAtivo = 0;
  bool enabled = false;

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
    initBackground(widget.id);
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

    setState(() {
      adicionatexto(resultados);
    });

    imageFuture = controller
        .renderImage(Size(width, height))
        .then<Uint8List?>((ui.Image image) => image.pngBytes);
    setState(() {});
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

      controller.addDrawables([
        TextDrawable(
            text: texto,
            position: Offset(dx, dy),
            scale: zoom,
            style: TextStyle(
                fontSize: fontSize,
                color: Colors.black,
                fontWeight: FontWeight.bold),
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
          Expanded(child: FutureImageVet(imageFuture: imageFuture)),
          if (legendas.isNotEmpty) testeDrop()
        ],
      );
    }
  }

  Widget criaButoesLegenda() {
    return ListView(
      children: legendas
          .map((legenda) => Padding(
                padding: EdgeInsets.only(bottom: 5, top: 5),
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
        child: Text(item,
            style: const TextStyle(
              fontSize: 20,
            )),
      ));

  DropdownButton testeDrop() {
    return DropdownButton(
        focusColor: Colors.transparent,
        alignment: Alignment.center,
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
