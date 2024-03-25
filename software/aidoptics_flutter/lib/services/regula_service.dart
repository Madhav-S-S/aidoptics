import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_face_api/face_api.dart' as Regula;
import 'package:path_provider/path_provider.dart';
import 'package:stacked_services/stacked_services.dart';

import '../app/app.locator.dart';
import '../app/app.logger.dart';

class RegulaService {
  final log = getLogger('RegulaService');
  final _snackbarService = locator<SnackbarService>();

  // late Regula.FaceSDK _faceSDK;

  Future<void> initPlatformState() async {
    log.i("Ragula init");
    Regula.FaceSDK.init().then((json) {
      var response = jsonDecode(json);
      log.i(response);
      if (!response["success"]) {
        log.i("Init failed: ");
        log.i(json);
      }
    });

    // const EventChannel('flutter_face_api/event/video_encoder_completion')
    //     .receiveBroadcastStream()
    //     .listen((event) {
    //   var response = jsonDecode(event);
    //   String transactionId = response["transactionId"];
    //   bool success = response["success"];
    //   log.i("video_encoder_completion:");
    //   log.i("    success: $success");
    //   log.i("    transactionId: $transactionId");
    // });
  }

  Future<Uint8List?> imageBitmap() async {
    final result = await Regula.FaceSDK.presentFaceCaptureActivity();
    if (result != null) {
      log.i("Result got");
      Regula.FaceCaptureResponse? response =
          Regula.FaceCaptureResponse.fromJson(json.decode(result));
      if (response != null && response.image != null) {
        log.i("Image response");
        Uint8List imageFile =
            base64Decode(response.image!.bitmap!.replaceAll("\n", ""));
        return imageFile;
      }
    }
    return null;
  }

  Future<String?> setFaceAndGetImagePath(String name) async {
    Uint8List? imageFile = await imageBitmap();
    if (imageFile != null) {
      log.i("Getting path..");
      // getting a directory path for saving
      final directory = await getApplicationDocumentsDirectory();
      File file = File(('${directory.path}/$name.png'));
      file.writeAsBytesSync(imageFile); // This is a sync operation on a real
      // return base64Encode(imageFile);
      return file.path;
    }
    return null;
  }

  Regula.MatchFacesImage getMatchFaceImage(String path) {
    final file = File(path).readAsBytesSync();
    final image = Regula.MatchFacesImage();
    image.bitmap = base64Encode(file);
    image.imageType = Regula.ImageType.LIVE;
    image.identifier = path.split('/').last.split('.').first;
    log.i("Image set:  $path type: ${image.imageType}");
    return image;
  }

  Future<List<Regula.MatchFacesImage>> getImagesStored() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    List<String> images = directory
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith(".png") && !item.contains("image"))
        .toList(growable: false);
    log.i(images);
    List<Regula.MatchFacesImage> rImages = <Regula.MatchFacesImage>[];
    for (var img in images) {
      rImages.add(getMatchFaceImage(img));
    }

    return rImages;
  }

  // final _image2 = Regula.MatchFacesImage();
  Future<String?> checkMatch(String path) async {
    Regula.MatchFacesImage _image1 = getMatchFaceImage(path);
    List<Regula.MatchFacesImage> rImages = await getImagesStored();
    //Comparing with each stored images
    for (final i in rImages) {
      double? value = await _checkMatch(_image1, i);
      if (value != null) {
        log.i(value);
        return i.identifier!;
      }
    }
    return null;
  }

  Future<double?> _checkMatch(
      Regula.MatchFacesImage _image1, Regula.MatchFacesImage _image2) async {
    if (_image1.bitmap != null && _image1.bitmap != "") {
      log.i("Image 1 ready");
    } else {
      _snackbarService.showSnackbar(
        message: "Image edit",
      );
      return null;
    }
    if (_image2.bitmap != null && _image2.bitmap != "") {
      log.i("Image 2 ready");
    } else {
      _snackbarService.showSnackbar(message: "Image edit");
      return null;
    }

    log.i("Checking face");
    // rImages.add(_image1);

    var request = Regula.MatchFacesRequest();
    request.images = [_image1, _image2];
    // log.i("request images: ${request.images.length}");
    String value = await Regula.FaceSDK.matchFaces(jsonEncode(request));
    if (value.contains("errorCode")) {
      _snackbarService.showSnackbar(
          message: "Error api call/Not detected face");
    }
    // log.i("Value> $value");
    Regula.MatchFacesResponse? response =
        Regula.MatchFacesResponse.fromJson(json.decode(value));
    String str = await Regula.FaceSDK.matchFacesSimilarityThresholdSplit(
        jsonEncode(response!.results), 0.75);

    Regula.MatchFacesSimilarityThresholdSplit? split =
        Regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));

    if (split!.matchedFaces.isNotEmpty) {
      log.i("MatchedFaces: ${split.matchedFaces}");
      log.i(
          "Matched face index: ${split.matchedFaces[0]!.first!.face!.faceIndex}");
      return (split.matchedFaces[0]!.similarity! * 100);
    }
    log.i('Not identified');

    return null;
  }
}