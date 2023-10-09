// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';

import 'dart:ui' as ui;

import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../Utils/mensagens.dart';
import '../Utils/utils.dart';
import '../Proxy/proxyimagens.dart';
import 'cadastraimagem.dart';

class CadastrarImagem extends StatefulWidget {
  const CadastrarImagem({Key? key}) : super(key: key);

  @override
  FlutterPainterExampleState createState() => FlutterPainterExampleState();
}

class FlutterPainterExampleState extends State<CadastrarImagem> {
  Utils utils = Utils();
  Uint8List? logoBase64;

  CadastraImagem cadImagem = CadastraImagem();
  Mensagem mensagem = Mensagem();
  int rotation = 0;
  ScrollController scrollTeste = ScrollController();

  int tamanhoFonte = 30;
  bool rodaUndo = false;

  TextEditingController fontController = TextEditingController();
  TextEditingController numeroImagemController = TextEditingController();
  TextEditingController legendaImagemController = TextEditingController();
  TextEditingController nomeImagemController = TextEditingController();

  List<Color> cores = [
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.yellow,
    const Color(0xffa00000),
    const Color(0xff0b226e),
    const Color(0xff14381e)
  ];

  // imagem com a legenda em outra tela, mas na mesma linha

  Map textoImagem = {
    'numero': '',
    'tamanhoFonte': 30,
    'cor': const Color(0xffa00000),
    'corBorda': Colors.yellow
  };

  List<String> legendas = [];
  List<Color> coresDestaque = [];
  List<Color> coresBorda = [];

  bool adicionandoTexto = false;
  bool atualizandoTexto = false;

  static Color red = const Color(0xFFFF0000);
  FocusNode textFocusNode = FocusNode(
      canRequestFocus: false,
      descendantsAreFocusable: false,
      descendantsAreTraversable: false);
  late PainterController controller;
  ui.Image? backgroundImage;
  Paint shapePaint = Paint()
    ..strokeWidth = 5
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  ProxyImagens imagemProxy = ProxyImagens().getInterface();

  @override
  void initState() {
    super.initState();
    fontController.text = tamanhoFonte.toString();
    controller = PainterController(
        settings: PainterSettings(
            text: TextSettings(
              focusNode: textFocusNode,
              textStyle: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            freeStyle: FreeStyleSettings(
              color: red,
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
    // Listen to focus events of the text field
    textFocusNode.addListener(onFocus);

    // Initialize background
  }

  void initBackground() async {
    logoBase64 = await utils.pickAndConvertImageToBytecode();
    if (logoBase64 != null) {
      final image = await MemoryImage(logoBase64!).image;
      setState(() {
        backgroundImage = image;
        controller.background = image.backgroundDrawable;
      });
    }
  }

  void onFocus() {
    if (controller.selectedObjectDrawable != null &&
        controller.selectedObjectDrawable.runtimeType == TextDrawable) {
      TextDrawable drawbleT = controller.selectedObjectDrawable as TextDrawable;
      print(drawbleT.rotationAngle);
      controller.textStyle = drawbleT.style;

      fontController.text = drawbleT.style.fontSize.toString();
      numeroImagemController.text = drawbleT.text;
      legendaImagemController.text =
          legendas[controller.drawables.indexOf(drawbleT)];
      textoImagem['cor'] =
          coresDestaque[controller.drawables.indexOf(drawbleT)];
      textoImagem['corBorda'] =
          coresBorda[controller.drawables.indexOf(drawbleT)];
    }

    textFocusNode.unfocus();

    adicionandoTexto = true;

    setState(() {});
  }

  Widget buildDefault(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, kToolbarHeight),
        // Listen to the controller and update the UI when it updates.
        child: ValueListenableBuilder<PainterControllerValue>(
            valueListenable: controller,
            child: Row(children: [
              IconButton(
                  onPressed: () {
                    initBackground();
                    for (var drawable in controller.drawables) {
                      controller.removeDrawable(drawable);
                    }
                  },
                  icon: Icon(PhosphorIcons.fill.image)),
            ]),
            builder: (context, _, child) {
              return AppBar(
                title: child,
                actions: [
                  // Delete the selected drawable
                  IconButton(
                    icon: Icon(
                      PhosphorIcons.fill.trash,
                    ),
                    onPressed: controller.selectedObjectDrawable == null
                        ? null
                        : removeSelectedDrawable,
                  ),
                  IconButton(
                    icon: Icon(
                      PhosphorIcons.fill.arrowClockwise,
                    ),
                    onPressed: controller.canRedo ? controller.redo : null,
                  ),
                  // Undo action
                  IconButton(
                    icon: Icon(
                      PhosphorIcons.fill.arrowCounterClockwise,
                    ),
                    onPressed: controller.canUndo ? controller.undo : null,
                  ),
                ],
              );
            }),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            if (backgroundImage != null) ...[
              TextField(
                  controller: nomeImagemController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome Imagem',
                  )),
              Expanded(
                  child: Stack(
                children: [
                  RotatedBox(
                    quarterTurns: rotation,
                    child: AspectRatio(
                      aspectRatio:
                          backgroundImage!.width / backgroundImage!.height,
                      child: FlutterPainter(
                        controller: controller,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: ValueListenableBuilder(
                      valueListenable: controller,
                      builder: (context, _, __) => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                                color: Colors.white54,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (adicionandoTexto) ...adicionaTexto(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
              ValueListenableBuilder(
                valueListenable: controller,
                builder: (context, _, __) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: IconButton(
                        icon: Icon(
                          PhosphorIcons.fill.textT,
                          color: adicionandoTexto ? Colors.yellow : null,
                        ),
                        onPressed: () {
                          setState(() {
                            adicionandoTexto = !adicionandoTexto;
                            controller.deselectObjectDrawable();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                          onPressed: () {
                            rotation += 1;
                            if (rotation == 4) {
                              rotation = 0;
                            }
                            setState(() {});
                          },
                          icon: const Icon(Icons.flip)),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(
                          PhosphorIcons.fill.floppyDisk,
                        ),
                        onPressed: () async {
                          var render = controller.painterKey.currentContext!
                              .findRenderObject() as RenderBox;
                          var insertedIT;

                          var inserted = await cadImagem.cadastraImagem(
                              logoBase64!,
                              nomeImagemController.text,
                              render.size.width,
                              render.size.height,
                              rotation);
                          int idImagem = inserted[0]['IdImagem'];

                          for (var drawables in controller.drawables) {
                            if (drawables.runtimeType == TextDrawable) {
                              int index =
                                  controller.drawables.indexOf(drawables);
                              insertedIT = await cadImagem.cadastrarImagemTexto(
                                  idImagem,
                                  legendas[index],
                                  coresDestaque[index],
                                  coresBorda[index],
                                  drawables as TextDrawable);
                              print(insertedIT);
                            }
                          }

                          print(idImagem);
                          controller.background = null;
                          controller.clearDrawables();
                          nomeImagemController.text = '';
                          setState(() {});

                          mensagem.mensagem(context, 'Cadastrado com Sucesso',
                              'Imagem cadastrada com sucesso', null);
                        },
                      ),
                    )
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  List<Widget> adicionaTexto() {
    return [
      const Divider(),
      Text(controller.selectedObjectDrawable == null
          ? 'Adicionar Número e Legenda'
          : 'Alterar Número ${(controller.selectedObjectDrawable as TextDrawable).text}'),
      const SizedBox(
        height: 5,
      ),
      TextField(
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          setState(() {});
        },
        controller: numeroImagemController,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), labelText: 'Inserir Número'),
      ),
      TextField(
        controller: legendaImagemController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Inserir Legenda',
        ),
      ),
      Row(
        children: [
          const Text('Tamanho da fonte'),
          const SizedBox(
            width: 5,
          ),
          Expanded(
              child: TextField(
            onChanged: (value) {
              if (value != '') {
                int fonte = int.parse(value);
                if (fonte >= 9 && fonte <= 100) {
                  setState(() {
                    tamanhoFonte = fonte;
                  });
                }
              }
            },
            textAlign: TextAlign.center,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: fontController,
          ))
        ],
      ),
      Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(
              icon: const Icon(Icons.text_decrease),
              onPressed: () {
                setState(() {
                  tamanhoFonte -= 1;
                  fontController.text = tamanhoFonte.toInt().toString();
                });
              }),
          const SizedBox(width: 5),
          IconButton(
              icon: const Icon(Icons.text_increase),
              onPressed: () {
                setState(() {
                  tamanhoFonte += 1;
                  fontController.text = tamanhoFonte.toInt().toString();
                });
              }),
        ]),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: cores
                .map(
                  (cor) => GestureDetector(
                    onTap: (() {
                      textoImagem['cor'] = cor;
                      setState(() {});
                    }),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: textoImagem['cor'] == cor
                                ? const Color.fromARGB(255, 249, 240, 158)
                                : Colors.black),
                        color: cor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                )
                .toList()),
      ),
      const SizedBox(
        height: 5,
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: cores
                .map(
                  (cor) => GestureDetector(
                    onTap: (() {
                      textoImagem['corBorda'] = cor;
                      setState(() {});
                    }),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: textoImagem['corBorda'] == cor
                                ? Colors.yellow
                                : Colors.black),
                        color: cor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                )
                .toList()),
      ),
      const SizedBox(
        height: 15,
      ),
      Text(
        numeroImagemController.text,
        style: TextStyle(
            color: textoImagem['cor'],
            shadows: [
              Shadow(
                  color: textoImagem['corBorda'], // Border color
                  offset: Offset(-2, -2),
                  blurRadius: 2.5 // Adjust this for border width
                  ),
              Shadow(
                  color: textoImagem['corBorda'], // Border color
                  offset: Offset(2, -2),
                  blurRadius: 2.5 // Adjust this for border width
                  ),
              Shadow(
                  color: textoImagem['corBorda'], // Border color
                  offset: Offset(-2, 2),
                  blurRadius: 2.5 // Adjust this for border width
                  ),
              Shadow(
                  color: textoImagem['corBorda'], // Border color
                  offset: Offset(2, 2),
                  blurRadius: 2.5 // Adjust this for border width
                  ),
            ],
            fontSize: tamanhoFonte.toDouble()),
      ),
      ElevatedButton(
          onPressed: () {
            textoImagem['fonteTamanho'] = tamanhoFonte.toDouble();
            textoImagem['numero'] = numeroImagemController.text;

            if (textoImagem['numero'] != '') {
              if (controller.selectedObjectDrawable == null &&
                  adicionandoTexto) {
                addText();
                legendas.add(legendaImagemController.text);
                coresDestaque.add(textoImagem['cor']);
                coresBorda.add(textoImagem['corBorda']);
              } else {
                atualizaText();
              }

              adicionandoTexto = false;
              resetaCampos();
              controller.deselectObjectDrawable();
              setState(() {});
            }
          },
          child: const Text('Inserir Texto')),
      const SizedBox(
        height: 5,
      ),
    ];
  }

  resetaCampos() {
    numeroImagemController.text = "";
    legendaImagemController.text = "";
    fontController.text = "30";
    textoImagem = {'numero': '', 'tamanhoFonte': 30, 'cor': null};
  }

  void atualizaText() {
    TextDrawable textT = controller.selectedObjectDrawable as TextDrawable;

    TextDrawable newDrawable = textT.copyWith(
        rotation: textT.rotationAngle,
        text: textoImagem['numero'],
        style: textT.style.copyWith(fontSize: textoImagem['fonteTamanho']));
    int index =
        controller.drawables.indexOf(controller.selectedObjectDrawable!);

    legendas[index] = legendaImagemController.text;
    coresDestaque[index] = textoImagem['cor'];
    coresBorda[index] = textoImagem['corBorda'];

    controller.replaceDrawable(controller.selectedObjectDrawable!, newDrawable);
    setState(() {});
  }

  void addText() {
    var render =
        controller.painterKey.currentContext!.findRenderObject() as RenderBox;

    controller.addDrawables([
      TextDrawable(
          text: textoImagem['numero'],
          position: Offset(render.size.width / 2, render.size.height / 2),
          style: TextStyle(
            shadows: [
              Shadow(
                color: textoImagem['corBorda'], // Border color
                offset: Offset(-2, -2), // Adjust this for border width
              ),
              Shadow(
                color: textoImagem['corBorda'], // Border color
                offset: Offset(2, -2), // Adjust this for border width
              ),
              Shadow(
                color: textoImagem['corBorda'], // Border color
                offset: Offset(-2, 2), // Adjust this for border width
              ),
              Shadow(
                color: textoImagem['corBorda'], // Border color
                offset: Offset(2, 2), // Adjust this for border width
              ),
            ],
            fontSize: textoImagem['fonteTamanho'],
            color: Colors.black,
          ))
    ]);

    controller.textStyle =
        controller.textStyle.copyWith(color: textoImagem['cor']);

    controller.textSettings = controller.textSettings.copyWith(
        textStyle: controller.textSettings.textStyle
            .copyWith(fontSize: textoImagem['fonteTamanho'].toDouble()));

    textoImagem['texto'] = '';
  }

  void removeSelectedDrawable() {
    final selectedDrawable = controller.selectedObjectDrawable;
    if (selectedDrawable != null) {
      legendas.removeAt(controller.drawables.indexOf(selectedDrawable));
      coresDestaque.removeAt(controller.drawables.indexOf(selectedDrawable));
      coresBorda.removeAt(controller.drawables.indexOf(selectedDrawable));
      controller.removeDrawable(selectedDrawable);
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildDefault(context);
  }
}
