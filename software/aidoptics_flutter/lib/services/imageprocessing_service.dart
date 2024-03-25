import 'dart:io';


import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../app/app.logger.dart';

class ImageProcessingService {
  final log = getLogger('ImageProcessing_Service');

  Future<List<String>> getLabelFromImage(File image) async {
    log.i("Getting label");
    final _labels = <String>[];

    final inputImage = InputImage.fromFilePath(image.path);
    final ImageLabelerOptions options =
        ImageLabelerOptions(confidenceThreshold: 0.5);
    final imageLabeler = ImageLabeler(options: options);

    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);

    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final double confidence = label.confidence;
      log.i("$index $text $confidence");
      // if (confidence > 0.65) {
      _labels.add(text);
      // }
    }

    imageLabeler.close();

    return _labels;
  }

  final List<String> _personLabels = [
    'Smile',
    'Fun',
    'Mouth',
    'Selfie',
    'Eyelash',
    'Beard',
    'Hand',
    'Moustache',
    'Skin',
    'Cool',
    'Ear',
    'Hair',
    'Dude',
  ];

  String processLabels(List<String> labeles) {
    if (labeles.isEmpty) return "Not recognized";
    check(String value) => labeles.contains(value);
    bool res = _personLabels.any(check); // returns true
    if (res) {
      return "Person detected";
    } else {
      if (labeles.contains("Dog")) labeles.remove("Dog");
      if (labeles.contains("Musical instrument")) {
        labeles.remove("Musical instrument");
      }
      if (labeles.isNotEmpty) {
        String text = labeles.first;
        return text;
      } else {
        return "";
      }
    }
  }

  // Future<String> getTextFromImage(File image) async {
  //   final inputImage = InputImage.fromFilePath(image.path);
  //   final ImageLabelerOptions options =
  //       ImageLabelerOptions(confidenceThreshold: 0.5);
  //   final imageLabeler = ImageLabeler(options: options);

  //   final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  //   final RecognizedText recognizedText =
  //       await textRecognizer.processImage(inputImage);

  //   String text = recognizedText.text;
  //   for (TextBlock block in recognizedText.blocks) {
  //     final Rect rect = block.boundingBox;
  //     final List<Point<int>> cornerPoints = block.cornerPoints;
  //     final String text = block.text;
  //     final List<String> languages = block.recognizedLanguages;

  //     for (TextLine line in block.lines) {
  //       // Same getters as TextBlock
  //       for (TextElement element in line.elements) {
  //         // Same getters as TextBlock
  //       }
  //     }
  //   }
  //   textRecognizer.close();
  //   return text;
  // }
  Future<String> getTextFromImage(File image) async {
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
    final inputImage = InputImage.fromFilePath(image.path);
    
    final RecognizedText recognizedText =
        (await textRecognizer.processImage(inputImage)) as RecognizedText;
    String text = recognizedText.text;
    textRecognizer.close();
    return text;
  }
}

/// Recognized text in an image.

// class RecognizedText {
//   /// String containing all the text identified in an image. The string is empty if no text was recognized.
//   final String text;

//   /// All the blocks of text present in image.
//   final List<TextBlock> blocks;

//   /// Constructor to create an instance of [RecognizedText].
//   RecognizedText({required this.text, required this.blocks});

//   /// Returns an instance of [RecognizedText] from a given [json].
//   factory RecognizedText.fromJson(Map<dynamic, dynamic> json) {
//     final resText = json['text'];
//     final textBlocks = <TextBlock>[];
//     for (final block in json['blocks']) {
//       final textBlock = TextBlock.fromJson(block);
//       textBlocks.add(textBlock);
//     }
//     return RecognizedText(text: resText, blocks: textBlocks);
//   }
// }
