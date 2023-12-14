import 'dart:convert';

import 'package:atlas_veterinario/CadImagem/geraimagem.dart';
import 'package:atlas_veterinario/Utils/IconButtonVoice.dart';
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
  final Map<String, dynamic> dadosPaginaImagem;
  const BuscarImagemPainter({Key? key, required this.dadosPaginaImagem})
      : super(key: key);

  @override
  BuscarImagemPainterState createState() => BuscarImagemPainterState();
}

class BuscarImagemPainterState extends State<BuscarImagemPainter> {
  ProxyImagens imagemProxy = ProxyImagens.instance;
  List<String> legendas = [];
  List<Color> coresDestaque = [];
  String nomeImagem = '';
  TextDrawable? old;
  bool isLegendas = false;
  String? legendaAtual;
  String legendaFiltrada = '';
  int rotationImagem = 1;
  int incrementalRotation = 0;
  bool isFalando = false;

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
    initBackground(widget.dadosPaginaImagem['IdImagem']!, 0);
  }

  void initBackground(int id, int rotation) async {
    Map resultados = await imagemProxy.find(id, false);
    Uint8List logoBase64 = base64.decode(resultados['Imagem']);
    final image = await MemoryImage(logoBase64).image;

    setState(() {
      backgroundImage = image;
      controller.background = image.backgroundDrawable;
    });

    width = resultados['Width'].runtimeType == int
        ? resultados['Width'].toDouble()
        : resultados['Width'];
    height = resultados['Height'].runtimeType == int
        ? resultados['Height'].toDouble()
        : resultados['Height'];

    rotationImagem = resultados['RotationImage'] + rotation;

    if (rotationImagem >= 4) {
      rotationImagem -= 4;
    }

    setState(() {
      adicionatexto(resultados, rotation);
    });

    imageFuture = controller
        .renderImage(Size(width, height))
        .then<Uint8List?>((ui.Image image) => image.pngBytes);
    setState(() {
      nomeImagem = resultados['NomeImagem'];
    });
  }

  adicionatexto(Map resultados, int rotation) {
    for (Map imagemTexto in resultados['Imagem_Texto']) {
      String texto = imagemTexto['Numero'];

      if (legendas.length <= resultados['Imagem_Texto'].length) {
        legendas.add("$texto ${imagemTexto['Legenda']}");
      }

      if (coresDestaque.length <= resultados['Imagem_Texto'].length) {
        coresDestaque.add(Color(imagemTexto['CorDestaque']));
      }

      Color corBorda = Color(imagemTexto['CorBorda']);

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
      double rotationImg = imagemTexto['Rotation'].toDouble();

      controller.addDrawables([
        TextDrawable(
            text: texto,
            position: Offset(dx, dy),
            scale: zoom,
            rotation: rotationImg + listRotation[rotation.toInt()],
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black,
              shadows: [
                Shadow(
                    color: corBorda, // Border color
                    offset: const Offset(-2, -2),
                    blurRadius: 2.5 // Adjust this for border width
                    ),
                Shadow(
                    color: corBorda, // Border color
                    offset: const Offset(2, -2),
                    blurRadius: 2.5 // Adjust this for border width
                    ),
                Shadow(
                    color: corBorda, // Border color
                    offset: const Offset(-2, 2),
                    blurRadius: 2.5 // Adjust this for border width
                    ),
                Shadow(
                    color: corBorda, // Border color
                    offset: const Offset(2, 2),
                    blurRadius: 2.5 // Adjust this for border width
                    ),
              ],
            ),
            locked: true)
      ]);
    }
  }

  Widget buildDefault(BuildContext context) {
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
                AutoSizeText(nomeImagem,
                    maxLines: 2,
                    minFontSize: 10,
                    style: const TextStyle(fontSize: 20)),
                const SizedBox(
                  width: 5,
                ),
                IconButtonVoice(cor: Colors.black, fala: nomeImagem),
                const Expanded(child: SizedBox()),
                const IconButtonVoice(
                    cor: Colors.black,
                    fala: 'Clique para rotacionar a imagem.'),
                IconButton(
                    tooltip: 'Clique para rotacionar a imagem.',
                    onPressed: () async {
                      setState(() {
                        incrementalRotation += 1;
                        if (incrementalRotation == 4) {
                          incrementalRotation = 0;
                        }
                      });
                      print(incrementalRotation);
                      legendas.clear();
                      controller.clearDrawables();
                      initBackground(widget.dadosPaginaImagem['IdImagem']!,
                          incrementalRotation);
                      await Future.delayed(const Duration(milliseconds: 100));
                      print(legendaAtual);
                      destacandoNumero(legendaAtual);
                      setState(() {});
                    },
                    icon: Icon(PhosphorIcons.fill.arrowClockwise)),
                IconButton(
                    tooltip: 'Clique para rotacionar a imagem.',
                    onPressed: () async {
                      setState(() {
                        incrementalRotation -= 1;
                        if (incrementalRotation < 0) {
                          incrementalRotation = 3;
                        }
                      });
                      print(incrementalRotation);
                      legendas.clear();
                      controller.clearDrawables();
                      initBackground(widget.dadosPaginaImagem['IdImagem']!,
                          incrementalRotation);
                      await Future.delayed(const Duration(milliseconds: 100));
                      print(legendaAtual);
                      destacandoNumero(legendaAtual);
                      setState(() {});
                    },
                    icon: Icon(PhosphorIcons.fill.arrowCounterClockwise))
              ],
            ),
          ),
        ),
        Expanded(
            child: Stack(
          children: [
            RotatedBox(
              quarterTurns: rotationImagem,
              child: InteractiveViewer(
                maxScale: 10,
                child: FutureImageVet(
                  imageFuture: imageFuture,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.black)),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Wrap(
                      direction: Axis.vertical,
                      children: [
                        Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.black)),
                            ),
                            child: textoFormatado(
                                '${widget.dadosPaginaImagem['Pagina']}')),
                        const SizedBox(
                          height: 5,
                        ),
                        RotatedBox(
                          quarterTurns: 3,
                          child: textoFormatado(
                              '${widget.dadosPaginaImagem['Capitulo']}'),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        RotatedBox(quarterTurns: 3, child: textoFormatado('P')),
                        RotatedBox(quarterTurns: 3, child: textoFormatado('A')),
                        RotatedBox(quarterTurns: 3, child: textoFormatado('C')),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        )),
        if (legendas.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: testeDrop()),
                IconButtonVoice(
                    cor: Colors.black,
                    fala: legendaAtual != null ? legendaFiltrada : '')
              ],
            ),
          )
      ],
    );
  }

  Text textoFormatado(String texto) {
    return Text(
      texto,
      style: const TextStyle(
          fontSize: 20.0,
          color: Color(0xff006600),
          fontWeight: FontWeight.bold),
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

  destacandoNumero(String? value) {
    if (old != null) {
      destacaNumero(old!, Colors.black);
    }
    print(value);

    if (value != null) {
      int index = legendas.indexOf(value);
      print(index);
      print(controller.drawables);
      destacaNumero(
          controller.drawables[index] as TextDrawable, coresDestaque[index]);
      old = controller.drawables[index] as TextDrawable;
    }
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

  DecoratedBox testeDrop() {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: Color(0xff23c423),
        shape: RoundedRectangleBorder(
          side: BorderSide(
              width: 1.0, style: BorderStyle.solid, color: Color(0xff386e41)),
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            dropdownColor: const Color(0xff23c423),
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            focusColor: Colors.transparent,
            alignment: Alignment.center,
            isExpanded: true,
            hint: const Text('Escolha a Parte do Membro'),
            value: legendaAtual,
            items:
                legendas.map((String valor) => buildMenuItem(valor)).toList(),
            onChanged: (value) async {
              print(value);
              destacandoNumero(value);
              setState(() {
                legendaAtual = value;
              });
              String valorTexto = legendaAtual!;

              int indexEspaco = valorTexto.indexOf(' ');
              valorTexto = valorTexto.substring(indexEspaco + 1);
              legendaFiltrada = valorTexto;
              setState(() {});
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildDefault(context);
  }
}
