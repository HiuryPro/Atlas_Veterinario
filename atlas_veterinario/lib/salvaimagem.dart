import 'dart:math';

import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import 'package:photo_view/photo_view.dart';

class SalvaImagem extends StatefulWidget {
  const SalvaImagem({super.key});

  @override
  State<SalvaImagem> createState() => _SalvaImagemState();
}

const double min = pi * -2;
const double max = pi * 2;

const double minScale = 0.1;
const double defScale = 0.1;
const double maxScale = 5;

class _SalvaImagemState extends State<SalvaImagem> {
  Uint8List? logoBase64;
  double? scaleCopy;

  late PhotoViewControllerBase controller;
  late PhotoViewScaleStateController scaleStateController;
  TextEditingController nomeController = TextEditingController();

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

  Future<Uint8List?> pickAndConvertImageToBytecode() async {
    final ImagePicker _picker = ImagePicker();

    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final Uint8List? imageBytes = await pickedImage.readAsBytes();
      return imageBytes;
    }

    return null;
  }

  Widget body() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/buscarImagem');
                },
                child: Text('Tela de buscar Imagem')),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    logoBase64 = await pickAndConvertImageToBytecode();
                  } catch (exception) {
                    print(exception);
                  }

                  setState(() {});
                },
                child: const Text('Escolhe imagem')),
            const SizedBox(height: 10),
            TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome da Imagem',
                )),
            SizedBox(
              height: 350.0,
              child: logoBase64 == null
                  ? Container(
                      color: Color(0xFFfafafa),
                    )
                  : ClipRect(
                      child: PhotoView(
                        controller: controller,
                        backgroundDecoration:
                            BoxDecoration(color: Color(0xFFfafafa)),
                        imageProvider: MemoryImage(logoBase64!),
                        maxScale: PhotoViewComputedScale.covered * 6.0,
                        minScale: PhotoViewComputedScale.contained * 0.8,
                        initialScale: PhotoViewComputedScale.covered,
                      ),
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(30.0),
              child: StreamBuilder(
                stream: controller.outputStateStream,
                initialData: controller.value,
                builder: _streamBuild,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    double dx = controller.position.dx;
                    double dy = controller.position.dy;
                    double zoom = controller.scale!;
                    String nomeImagem = nomeController.text;

                    String encodedString = base64.encode(logoBase64!);
                    print(encodedString);
                    await SupaDB.instance.clienteSupaBase
                        .from('Images')
                        .insert({
                      'Image': encodedString,
                      'NomeImagem': nomeImagem,
                      'Dx': dx,
                      'Dy': dy,
                      'Zoom': zoom
                    });
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text("Salva no banco"))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }

  Widget _streamBuild(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasError || !snapshot.hasData) {
      return Container();
    }
    final PhotoViewControllerValue value = snapshot.data;
    return Column(
      children: <Widget>[
        Text(
          "Zoom ${value.scale}",
          style: const TextStyle(color: Colors.black),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.orange,
            thumbColor: Colors.orange,
          ),
          child: Slider(
            value: value.scale!.clamp(minScale, maxScale),
            min: minScale,
            max: maxScale,
            onChanged: (double newScale) {
              print(controller.position.dx);
              print(controller.position.dy);
              print(controller.scale);
              controller.scale = newScale;
            },
          ),
        ),
        Text(
          "Posição X ${value.position.dx}        Posição Y ${value.position.dy}",
          style: const TextStyle(color: Colors.black),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.orange,
            thumbColor: Colors.orange,
          ),
          child: Slider(
            value: value.position.dx,
            min: -2000.0,
            max: 2000.0,
            onChanged: (double newPosition) {
              controller.position = Offset(newPosition, controller.position.dy);
            },
          ),
        ),
        Text(
          "Rotaçãof ${value.rotation}",
          style: const TextStyle(color: Colors.black),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.orange,
            thumbColor: Colors.orange,
          ),
          child: Slider(
            value: value.position.dx,
            min: -2000,
            max: 2000,
            onChanged: (double newRotation) {
              controller.rotation = newRotation;
            },
          ),
        ),
      ],
    );
  }
}
