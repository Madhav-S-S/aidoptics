import 'package:aidoptics_flutter/ui/common/ui_helpers.dart';
import 'package:aidoptics_flutter/widgets/ip.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'hardware_viewmodel.dart';

class HardwareView extends StatelessWidget {
  const HardwareView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HardwareViewModel>.reactive(
      onViewModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        // print(model.node?.lastSeen);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Hardware'),
            actions: [
              // IconButton(
              //     onPressed: () {
              //       // Navigator.of(context)
              //       // .push(MaterialPageRoute(builder: (context) => MyApp()));
              //     },
              //     icon: Icon(Icons.speaker),
              // ),

              if (model.ip != null)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.developer_board, color: Colors.amber),
                ),
            ],
          ),
          floatingActionButton: model.ip != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      heroTag : '123',
                      onPressed: () {
                        model.workLabel();
                      },
                      tooltip: 'camera',
                      child: Icon(Icons.camera_alt),
                    ),
                    horizontalSpaceSmall,
                    FloatingActionButton(
                      heroTag : 'fdf',
                      onPressed: () {
                        model.workText();
                      },
                      tooltip: 'Text',
                      child: Icon(Icons.text_fields_rounded),
                    ),
                  ],
                )
              : null,
          body: Center(
            child: (model.isBusy)
                ? const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: CircularProgressIndicator(),
                  )
                : (model.imageSelected != null &&
                        model.imageSelected!.path != "")
                    ? Expanded(
                        child: RotatedBox(
                          quarterTurns: 0,
                          child: Image.memory(model.img!
                              // model.imageSelected!.readAsBytesSync(),
                              ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              if (model.imageSelected == null ||
                                  model.imageSelected!.path == "")
                                IpAddressInputWidget(
                                  onSetIp: model.setIp,
                                  initialIp: model.ip,
                                ),
                              verticalSpaceMassive,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text("DL : ${model.distanceLeft} cm"),
                                  ElevatedButton(
                                      onPressed: model
                                          .getUltrasonicDistanceFromHardware,
                                      child: const Text("Get distance")),
                                  Text("DR: ${model.distanceRight} cm"),
                                ],
                              ),
                              verticalSpaceMassive,
                              // if(model.isDistanceTimer)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  if (model.isLeftObstacle)
                                    const Text("Obstacle from left"),
                                  ElevatedButton(
                                      onPressed: model.getObstacles,
                                      child: const Text("Get obstacle data")),
                                  if (model.isRightObstacle)
                                    const Text("Obstacle from right"),
                                ],
                              ),
                              //verticalSpaceLarge,
                              if (model.isBusy)
                                const Padding(
                                  padding: EdgeInsets.all(24.0),
                                  child: CircularProgressIndicator(),
                                ),
                              if (model.imageSelected != null &&
                                  model.imageSelected!.path != "")
                                Expanded(
                                  child: SizedBox(
                                    height: 200,
                                    child: RotatedBox(
                                      quarterTurns: 1,
                                      child: Image.memory(model.img!
                                          // model.imageSelected!.readAsBytesSync(),
                                          ),
                                    ),
                                  ),
                                ),
                              // if (model.labels.isNotEmpty)
                              //   Expanded(
                              //     child: Padding(
                              //       padding: const EdgeInsets.all(14.0),
                              //       child: Text(
                              //         model.labels.toString(),
                              //         textAlign: TextAlign.center,
                              //         style: TextStyle(
                              //           fontWeight: FontWeight.bold,
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // TextButton(
                              //   onPressed: () async {
                              //     await model.getImageFromHardware();
                              //     model.getLabel();
                              //     print("get label");
                              //   },
                              //   child: Text(
                              //     "Get label",
                              //   ),
                              // ),
                            ]),
                      ),
          ),
        );
      },
      viewModelBuilder: () => HardwareViewModel(),
    );
  }
}
