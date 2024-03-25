import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/camera_service.dart';
import '../services/imageprocessing_service.dart';
import '../services/regula_service.dart';
import '../services/tts_service.dart';
import '../ui/bottom_sheets/notice/notice_sheet.dart';
import '../ui/dialogs/info_alert/info_alert_dialog.dart';
import '../ui/views/face/facerec_view.dart';
import '../ui/views/hardware/hardware_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/inapp/inapp_view.dart';
import '../ui/views/startup/startup_view.dart';
import 'package:aidoptics_flutter/ui/views/text/text_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: InAppView),
    MaterialRoute(page: FaceRecView),
    MaterialRoute(page: HardwareView),
    MaterialRoute(page: TextView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: TTSService),
    LazySingleton(classType: ImageProcessingService),
    LazySingleton(classType: RegulaService),
    LazySingleton(classType: CameraService),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
  logger: StackedLogger(),
)
class App {}
