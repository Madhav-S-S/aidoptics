import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'text_viewmodel.dart';

class TextView extends StatelessWidget {
  const TextView({Key? key}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TextViewModel>.reactive(
      onViewModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Text'),
            actions: [
              IconButton(
                onPressed: () {
                  // print("icon b");
                  model.speak("This is test speech output");
                },
                icon: const Icon(Icons.volume_up),
              ),
            ],
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                 // model.getImageCamera();
                  model.captureImageAndText();
                },
                tooltip: 'camera',
                child: Icon(Icons.add_a_photo),
                heroTag: null,
              ),
              SizedBox(width: 10),
              FloatingActionButton(
                onPressed: () {
                  model.getImageGallery();
                },
                tooltip: 'gallery',
                child: Icon(Icons.image),
                heroTag: null,
              )
            ],
          ),
          body: model.isBusy
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: Container(
                    child: model.imageSelected != null
                        ? Column(
                            children: [
                              Expanded(child: Image.file(model.imageSelected!)),
                              if (model.text.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    model.text.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: IconButton(
                              //     icon: Icon(Icons.volume_down_outlined),
                              //     onPressed: model.getLabel,
                              //   ),
                              // ),
                              TextButton(
                                onPressed: () {
                                  model.getText();
                                  // print("get Text");
                                },
                                child: const Text(
                                  "Get Text",
                                ),
                              ),
                            ],
                          )
                        : CameraPreview(model.controller),

                    // const Text("No images selected!")
                  ),
                ),
        );
      },
      viewModelBuilder: () => TextViewModel(),
    );
  }
}
