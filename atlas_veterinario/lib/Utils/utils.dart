import 'dart:typed_data';
import 'dart:ui';

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
}
