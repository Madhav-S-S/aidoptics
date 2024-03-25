import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.bottomsheets.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../app/app.router.dart';
import '../../../services/tts_service.dart';
import '../../common/app_strings.dart';

class HomeViewModel extends BaseViewModel {
  final log = getLogger('HomeViewModel');

  final _snackBarService = locator<SnackbarService>();
  final _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final TTSService _ttsService = locator<TTSService>();

  late Timer _reminderTimer;

  void onModelRdy() async {
    log.i("started");
    setBusy(true);
  }

  void openInAppView() {
    _navigationService.navigateTo(Routes.inAppView);
  }

  void openHardwareView() {
    _navigationService.navigateTo(Routes.hardwareView);
  }

  void openFaceTrainView() {
    _navigationService.navigateTo(Routes.faceRecView);
  }
  void openTextView() {
    _navigationService.navigateTo(Routes.textView);
  }

  void showBottomSheetUserSearch() async {
    final result = await _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.notice,
      title: ksHomeBottomSheetTitle,
      description: ksHomeBottomSheetDescription,
    );
    if (result != null) {
      if (result.confirmed) {
        log.i("Bystander added: ${result.data.fullName}");
        _snackBarService.showSnackbar(
            message: "${result.data.fullName} added as bystander");
      }
      // _bottomSheetService.
    }
  }
}
