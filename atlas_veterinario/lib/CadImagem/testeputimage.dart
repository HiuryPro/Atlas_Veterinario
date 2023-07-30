import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';

import 'dart:ui' as ui;

import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../Utils/utils.dart';
import '../Proxy/proxyimagens.dart';
import 'cadastraimagem.dart';

class FlutterPainterExample extends StatefulWidget {
  const FlutterPainterExample({Key? key}) : super(key: key);

  @override
  FlutterPainterExampleState createState() => FlutterPainterExampleState();
}

class FlutterPainterExampleState extends State<FlutterPainterExample> {
  Utils utils = Utils();
  Uint8List? logoBase64;

  CadastraImagem cadImagem = CadastraImagem();

  Color cores1 = Color(int.parse('0xFF000000'));
  int tamanhoFonte = 12;
  TextEditingController fontController = TextEditingController();
  TextEditingController textoImagemController = TextEditingController();
  TextEditingController nomeImagemController = TextEditingController();

  List<Color> cores = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.green,
    Colors.blue,
  ];

  Map textoImagem = {'texto': '', 'tamanhoFonte': 12, 'cor': null};

  List<Map> imagemTextoDb = [];
  List<Map> imagemSetaDb = [];
  List<Map> imagemContornoDb = [];

  bool adicionandoTexto = false;

  static Color red = const Color(0xFFFF0000);
  FocusNode textFocusNode = FocusNode();
  late PainterController controller;
  ui.Image? backgroundImage;
  Paint shapePaint = Paint()
    ..strokeWidth = 5
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  ProxyImagens imagemProxy = ProxyImagens.instance;

  @override
  void initState() {
    super.initState();
    cores.add(cores1);
    fontController.text = tamanhoFonte.toString();
    controller = PainterController(
        settings: PainterSettings(
            text: TextSettings(
              textStyle: TextStyle(
                  fontWeight: FontWeight.bold, color: red, fontSize: 18),
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

  /// Fetches image from an [ImageProvider] (in this example, [NetworkImage])
  /// to use it as a background
  void initBackground() async {
    // Extension getter (.image) to get [ui.Image] from [ImageProvider]

    logoBase64 = await utils.pickAndConvertImageToBytecode();
    final image = await MemoryImage(logoBase64!).image;

    setState(() {
      backgroundImage = image;
      controller.background = image.backgroundDrawable;
    });
  }

  /// Updates UI when the focus changes
  void onFocus() {
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
                const Text("Flutter Painter Example"),
                IconButton(
                    onPressed: () {
                      initBackground();
                      for (var drawable in controller.drawables) {
                        controller.removeDrawable(drawable);
                      }
                    },
                    icon: Icon(PhosphorIcons.fill.image))
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
                    // Delete the selected drawable
                    IconButton(
                      icon: const Icon(
                        Icons.flip,
                      ),
                      onPressed: controller.selectedObjectDrawable != null &&
                              controller.selectedObjectDrawable is ImageDrawable
                          ? flipSelectedImageDrawable
                          : null,
                    ),
                    // Redo action
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
        body: Stack(
          children: [
            if (backgroundImage != null)
              Column(
                children: [
                  TextField(
                      controller: nomeImagemController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Senha',
                      )),
                  Flexible(
                      child: AspectRatio(
                    aspectRatio:
                        backgroundImage!.width / backgroundImage!.height,
                    child: FlutterPainter(
                      controller: controller,
                    ),
                  )),
                ],
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
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: const BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                          color: Colors.white54,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (controller.freeStyleMode !=
                                FreeStyleMode.none) ...[
                              const Divider(),
                              const Text("Free Style Settings"),
                              // Control free style stroke width
                              Row(
                                children: [
                                  const Expanded(
                                      flex: 1, child: Text("Stroke Width")),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                        min: 0.1,
                                        max: 25,
                                        value: controller.freeStyleStrokeWidth,
                                        onChanged: setFreeStyleStrokeWidth),
                                  ),
                                ],
                              ),
                              if (controller.freeStyleMode ==
                                  FreeStyleMode.draw)
                                Row(
                                  children: [
                                    const Expanded(
                                        flex: 1, child: Text("Color")),
                                    // Control free style color hue
                                    Expanded(
                                      flex: 3,
                                      child: Slider.adaptive(
                                          min: 0,
                                          max: 359.99,
                                          value: HSVColor.fromColor(
                                                  controller.freeStyleColor)
                                              .hue,
                                          activeColor:
                                              controller.freeStyleColor,
                                          onChanged: setFreeStyleColor),
                                    ),
                                  ],
                                ),
                            ],
                            if (adicionandoTexto) ...adicionaTexto(),
                            if (controller.shapeFactory != null) ...[
                              const Divider(),
                              const Text("Shape Settings"),

                              // Control text color hue
                              Row(
                                children: [
                                  const Expanded(
                                      flex: 1, child: Text("Stroke Width")),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                        min: 0.1,
                                        max: 25,
                                        value: controller
                                                .shapePaint?.strokeWidth ??
                                            shapePaint.strokeWidth,
                                        onChanged: (value) =>
                                            setShapeFactoryPaint(
                                                (controller.shapePaint ??
                                                        shapePaint)
                                                    .copyWith(
                                              strokeWidth: value,
                                            ))),
                                  ),
                                ],
                              ),

                              // Control shape color hue
                              Row(
                                children: [
                                  const Expanded(flex: 1, child: Text("Color")),
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                        min: 0,
                                        max: 359.99,
                                        value: HSVColor.fromColor(
                                                (controller.shapePaint ??
                                                        shapePaint)
                                                    .color)
                                            .hue,
                                        activeColor: (controller.shapePaint ??
                                                shapePaint)
                                            .color,
                                        onChanged: (hue) =>
                                            setShapeFactoryPaint(
                                                (controller.shapePaint ??
                                                        shapePaint)
                                                    .copyWith(
                                              color: HSVColor.fromAHSV(
                                                      1, hue, 1, 1)
                                                  .toColor(),
                                            ))),
                                  ),
                                ],
                              )
                            ]
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, _, __) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Free-style eraser
              IconButton(
                icon: Icon(
                  PhosphorIcons.fill.eraser,
                  color: controller.freeStyleMode == FreeStyleMode.erase
                      ? Colors.yellow
                      : null,
                ),
                onPressed: toggleFreeStyleErase,
              ),
              // Free-style drawing
              IconButton(
                icon: Icon(
                  PhosphorIcons.fill.scribbleLoop,
                  color: controller.freeStyleMode == FreeStyleMode.draw
                      ? Colors.yellow
                      : null,
                ),
                onPressed: () {
                  toggleFreeStyleDraw();
                  controller.shapeFactory = null;
                },
              ),
              // Add text
              IconButton(
                icon: Icon(
                  PhosphorIcons.fill.textT,
                  color: textFocusNode.hasFocus ? Colors.yellow : null,
                ),
                onPressed: () {
                  setState(() {
                    adicionandoTexto = true;
                    controller.freeStyleMode = FreeStyleMode.none;
                    controller.shapeFactory = null;
                  });
                },
              ),
              // Add shapes
              IconButton(
                icon: Icon(
                  PhosphorIcons.fill.arrowUpRight,
                  color: controller.shapeFactory != null ? Colors.yellow : null,
                ),
                onPressed: () {
                  controller.shapeFactory = ArrowFactory();
                  controller.freeStyleMode = FreeStyleMode.none;
                  setState(() {});
                },
              ),
              IconButton(
                icon: Icon(
                  PhosphorIcons.fill.floppyDisk,
                  color: controller.shapeFactory != null ? Colors.yellow : null,
                ),
                onPressed: () async {
                  var insertedIT;
                  var inserted = await cadImagem.cadastraImagem(
                      logoBase64!, nomeImagemController.text);
                  int idImagem = inserted[0]['IdImagem'];

                  for (var drawables in controller.drawables) {
                    if (drawables.runtimeType == TextDrawable) {
                      insertedIT = await cadImagem.cadastrarImagemTexto(
                          idImagem, drawables as TextDrawable);
                      print(insertedIT);
                    } else if (drawables.runtimeType == ArrowDrawable) {
                      insertedIT = await cadImagem.cadastrarImagemSeta(
                          idImagem, drawables as ArrowDrawable);
                      print(insertedIT);
                    } else if (drawables.runtimeType == FreeStyleDrawable) {
                      insertedIT = await cadImagem.cadastrarImagemContorno(
                          idImagem, drawables as FreeStyleDrawable);
                      print(insertedIT);
                    }
                  }

                  print(idImagem);
                },
              )
            ],
          ),
        ));
  }

  List<Widget> adicionaTexto() {
    return [
      const Divider(),
      TextField(
        controller: textoImagemController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Inserir Texto',
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
      Row(
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
                    border: Border.all(width: 2),
                    color: cor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            )
            .toList(),
      ),
      const SizedBox(
        height: 15,
      ),
      ElevatedButton(
          onPressed: () {
            textoImagem['fonteTamanho'] = tamanhoFonte;
            textoImagem['texto'] = textoImagemController.text;
            if (textoImagem['texto'] != '') {
              addText();
              adicionandoTexto = false;
              setState(() {});
            }
          },
          child: const Text('Inserir Texto')),
      const SizedBox(
        height: 5,
      ),
    ];
  }

  void toggleFreeStyleDraw() {
    controller.freeStyleMode = controller.freeStyleMode != FreeStyleMode.draw
        ? FreeStyleMode.draw
        : FreeStyleMode.none;
  }

  void toggleFreeStyleErase() {
    controller.freeStyleMode = controller.freeStyleMode != FreeStyleMode.erase
        ? FreeStyleMode.erase
        : FreeStyleMode.none;
  }

  void addText() {
    var render =
        controller.painterKey.currentContext!.findRenderObject() as RenderBox;

    controller.addDrawables([
      TextDrawable(
          text: textoImagem['texto'],
          position: Offset(render.size.width / 2, render.size.height / 2),
          style: TextStyle(
              fontSize: textoImagem['fonteTamanho'].toDouble(),
              color: textoImagem['cor'],
              fontWeight: FontWeight.bold))
    ]);

    controller.textStyle =
        controller.textStyle.copyWith(color: textoImagem['cor']);

    controller.textSettings = controller.textSettings.copyWith(
        textStyle: controller.textSettings.textStyle
            .copyWith(fontSize: textoImagem['fonteTamanho'].toDouble()));

    textoImagem['texto'] = '';
  }

  void setFreeStyleStrokeWidth(double value) {
    controller.freeStyleStrokeWidth = value;
  }

  void setFreeStyleColor(double hue) {
    controller.freeStyleColor = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
  }

  void setShapeFactoryPaint(Paint paint) {
    // Set state is just to update the current UI, the [FlutterPainter] UI updates without it
    setState(() {
      controller.shapePaint = paint;
    });
  }

  void removeSelectedDrawable() {
    final selectedDrawable = controller.selectedObjectDrawable;
    if (selectedDrawable != null) controller.removeDrawable(selectedDrawable);
  }

  void flipSelectedImageDrawable() {
    final imageDrawable = controller.selectedObjectDrawable;
    if (imageDrawable is! ImageDrawable) return;

    controller.replaceDrawable(
        imageDrawable, imageDrawable.copyWith(flipped: !imageDrawable.flipped));
  }

  @override
  Widget build(BuildContext context) {
    return buildDefault(context);
  }
}
