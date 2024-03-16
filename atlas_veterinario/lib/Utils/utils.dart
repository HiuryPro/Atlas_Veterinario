import 'dart:typed_data';
import 'package:atlas_veterinario/Fala/textoprafala.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
  List<Offset> parsePathStringToOffsetList(String offsetString) {
    // Regular expression to match numeric values within 'Offset' parentheses
    final regex = RegExp(r'Offset\((\d+\.\d+), (\d+\.\d+)\)');

    // Find all matches in the input string
    Iterable<RegExpMatch> matches = regex.allMatches(offsetString);

    // Create a list of Offset objects from the matched values
    List<Offset> offsetList = matches.map((match) {
      double x = double.parse(match.group(1)!);
      double y = double.parse(match.group(2)!);
      return Offset(x, y);
    }).toList();

    return offsetList;
  }

  List<Offset> parseStringDoubleListToOffsetList(String offsetString) {
    // Regular expression to match numeric values within each pair of brackets
    final regex = RegExp(r'\[(\d+\.\d+), (\d+\.\d+)\]');

    // Find all matches in the input string
    Iterable<RegExpMatch> matches = regex.allMatches(offsetString);

    // Create a list of Offset objects from the matched values
    List<Offset> offsetList = matches.map((match) {
      double x = double.parse(match.group(1)!);
      double y = double.parse(match.group(2)!);
      return Offset(x, y);
    }).toList();

    return offsetList;
  }

  List<List<double>> parseOffsetToListListDouble(List<Offset> offsets) {
    List<List<double>> offsetList = offsets.map((offset) {
      double x = offset.dx;
      double y = offset.dy;
      return [x, y];
    }).toList();

    return offsetList;
  }

  List<Offset> parseListDoubleToOffset(List<List<double>> doubles) {
    return doubles.map((listD) => Offset(listD[0], listD[1])).toList();
  }

  Future<Uint8List?> pickAndConvertImageToBytecode() async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final Uint8List imageBytes = await pickedImage.readAsBytes();
      return imageBytes;
    }

    return null;
  }

  GestureDetector retornaFala(
      BuildContext context, Widget widget, String fala) {
    return GestureDetector(
      onLongPress: () async {
        await Fala.instance.flutterTts.stop();
        await Fala.instance.flutterTts.speak(fala);
      },
      onDoubleTap: () async {
        await Fala.instance.flutterTts.stop();
      },
      child: widget,
    );
  }

  Future<void> falar(String fala, bool isAtivo) async {
    await Fala.instance.flutterTts.stop();

    if (isAtivo) {
      await Fala.instance.flutterTts.speak(fala);
    }
  }

  Text textoFormatado(String texto) {
    return Text(
      texto,
      style: const TextStyle(
          fontSize: 20.0,
          color: Color(0xff1a4683),
          fontWeight: FontWeight.bold),
    );
  }

  Align numeroPagina(String numero) {
    return Align(
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
                      border: Border(bottom: BorderSide(color: Colors.black)),
                    ),
                    child: textoFormatado(numero)),
              ],
            ),
          )),
    );
  }
}
