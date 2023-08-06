import 'dart:convert';

import 'package:atlas_veterinario/CadImagem/geraimagem.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';

import 'dart:ui' as ui;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Utils/utils.dart';
import '../Proxy/proxyimagens.dart';

class BuscarImagemPainter extends StatefulWidget {
  final int id;
  const BuscarImagemPainter({Key? key, required this.id}) : super(key: key);

  @override
  BuscarImagemPainterState createState() => BuscarImagemPainterState();
}

class BuscarImagemPainterState extends State<BuscarImagemPainter> {
  ProxyImagens imagemProxy = ProxyImagens.instance;
  List<String> legendas = [];
  List<Color> coresDestaque = [];
  TextDrawable? old;

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

    setState(() {});

    adicionatexto(resultados);
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
    return Column(
      children: [
        Expanded(
          child: CarouselSlider(
              items: [
                if (backgroundImage != null)
                  Center(
                    child: AspectRatio(
                        aspectRatio:
                            backgroundImage!.width / backgroundImage!.height,
                        child: FutureImageVet(imageFuture: imageFuture)),
                  ),
                criaButoesLegenda()
              ],
              carouselController: carouselController,
              options: CarouselOptions(
                initialPage: 0,
                viewportFraction: 1,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    indexAtivo = index;
                  });
                },
                enableInfiniteScroll: false,
              )),
        ),
        Center(
            child: AnimatedSmoothIndicator(
          activeIndex: indexAtivo,
          count: 2,
          onDotClicked: (index) {
            setState(() {
              print(index);
              indexAtivo = index;
              carouselController.animateToPage(indexAtivo,
                  duration: const Duration(milliseconds: 500));
            });
          },
        )),
      ],
    );
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
                        carouselController.animateToPage(0,
                            duration: const Duration(milliseconds: 500));
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

  @override
  Widget build(BuildContext context) {
    return buildDefault(context);
  }
}
