import 'dart:async';
import 'dart:io';

import 'package:aidoptics_flutter/app/app.locator.dart';
import 'package:aidoptics_flutter/app/app.logger.dart';
import 'package:aidoptics_flutter/services/camera_service.dart';
import 'package:aidoptics_flutter/services/imageprocessing_service.dart';
import 'package:aidoptics_flutter/services/regula_service.dart';
import 'package:aidoptics_flutter/services/tts_service.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class TextViewModel extends BaseViewModel {
  final log = getLogger('InAppViewModel');

  final _snackBarService = locator<SnackbarService>();

  final TTSService _ttsService = locator<TTSService>();
  final ImageProcessingService _imageProcessingService =
      locator<ImageProcessingService>();
  //final _ragulaService = locator<RegulaService>();
  final _camService = locator<CameraService>();

  CameraController get controller => _camService.controller;
  late StreamSubscription<double> _subscription;

  void onModelReady() async {
    _subscription = PerfectVolumeControl.stream.listen((value) {
      if (_image == null && !isBusy) {
        captureImageAndText();
      }
      if (_image != null && !isBusy) {
        log.i("Volume button got!");
        getText();
      }
    });
    setBusy(true);
    await _camService.initCam();
    setBusy(false);
    // setTimer();//todo
  }

  Future captureImageAndText() async {
    _image = await _camService.takePicture();
    getText();
  }

  Timer? _timer;

  void setTimer() {
    _timer = Timer.periodic(const Duration(seconds: 6), (Timer timer) async {
      log.i("Timer got!");
      if (_image == null && !isBusy) {
        captureImageAndText();
      }
      if (_image != null && !isBusy) {
        getText();
      }
    });
  }

  @override
  void dispose() {
    // call your function here
    _camService.dispose();
    _subscription.cancel();
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    super.dispose();
  }

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  File? _image;

   File? get imageSelected => _image;

  getImageCamera() async {
    setBusy(true);
    // picking image
    _imageFile = await _picker.pickImage(source: ImageSource.camera);

    if (_imageFile != null) {
      log.i("CCC");
      // _dlibService.addImageFace(await _imageFile!.readAsBytes());
      _image = File(_imageFile!.path);
    } else {
      _snackBarService.showSnackbar(message: "No images selected");
    }
    setBusy(false);
  }

  getImageGallery() async {
    setBusy(true);
    // picking image
    _imageFile = await _picker.pickImage(source: ImageSource.gallery);

    if (_imageFile != null) {
      _image = File(_imageFile!.path);
    } else {
      _snackBarService.showSnackbar(message: "No images selected");
    }
    setBusy(false);
  }

  String? _text;

  String get text => _text.toString();

  void getText() async {
    setBusy(true);
    log.i("Getting Text");

   

    _text = await _imageProcessingService.getTextFromImage(_image!);

    setBusy(false);

    // _image != await _ttsService.speak(_texts);

    if (_image != null) {
      await _ttsService.speak(_text.toString());
    } else {
      await _ttsService.speak('Not Detected');
    }
  }

  Future speak(String text) async {
    _ttsService.speak(text);
  }
}
