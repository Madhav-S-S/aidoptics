import 'dart:io';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

import '../app/app.logger.dart';

class CameraService {
  final log = getLogger('CameraService');

  late List<CameraDescription> _cameras;
  late CameraController controller;

  Future initCam() async {
    _cameras = await availableCameras();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    try {
      await controller.initialize();
    }

    // .then((_) async {
    //   log.i("Camera ready");
    // }).catchError((Object e) {
    // }).
    //
    catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    }
  }

  Future<File> takePicture() async {
    XFile img = await controller.takePicture();
    // final cmpImg = await compressImage(img.path);
    // return cmpImg;
    return File(img.path);
  }

  void dispose() {
    controller.dispose();
  }

  Future<File> compressImage(String path) async {
    // Use compute to compress the image in a separate isolate
    // Create a new file for the compressed image
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // String _path = path.join(appDocDir.path, 'compressed_image.jpg');

    final receivePort = ReceivePort();
    await Isolate.spawn(_compressImage, {
      'inputPath': path,
      'outputPath': path,
      'sendPort': receivePort.sendPort,
    });
    final croppedFilePath = await receivePort.first;
    return File(croppedFilePath);
  }

// This function is run in a separate isolate using compute
  void _compressImage(dynamic message) {
    final inputPath = message['inputPath'];
    final outputPath = message['outputPath'];
    final sendPort = message['sendPort'];

    File imageFile = File(inputPath);

    // Read the image data from the file
    final imageData = imageFile.readAsBytesSync();

    // Load the image from the raw bytes
    img.Image? image = img.decodeImage(imageData);

    if (image == null) sendPort.send(imageFile.path);
    log.i("Compressing");
    // Resize the image to reduce file size
    img.Image resizedImage = img.copyResize(image!, width: 800);

    // Encode the compressed image as JPEG
    List<int> compressedImageData = img.encodeJpg(resizedImage, quality: 75);

    File compressedImageFile = File(outputPath);

    // Write the compressed image data to the new file
    compressedImageFile.writeAsBytesSync(compressedImageData);

    sendPort.send(compressedImageFile.path);
  }
}
