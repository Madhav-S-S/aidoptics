import 'dart:io';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'facerec_viewmodel.dart';

class FaceRecView extends StatelessWidget {
  const FaceRecView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FaceRecViewModel>.reactive(
      onViewModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        void _showBottomSheet(BuildContext context) async {
          final result = await showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return MyBottomSheet();
            },
          );

          if (result != null) {
            model.setName(result);
          } else {
            print("No data");
          }
        }

        // print(model.node?.lastSeen);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Face train'),
            actions: [
              if (model.isBusy)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showBottomSheet(context);
              // model.work();
            },
            tooltip: 'camera',
            child: Icon(Icons.add_a_photo_outlined),
          ),
          body: Container(
              child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  if (model.images.isNotEmpty)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          children: model.images
                              .map(
                                (i) => Stack(
                                  children: [
                                    Positioned.fill(
                                      child: Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.grey[200],
                                        ),
                                        child: Image.file(
                                          File(i),
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          color: Colors.teal.withOpacity(0.5),
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  i.split("/").last,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: IconButton(
                                          onPressed: () {
                                            model.deleteImage(i);
                                          },
                                          icon: Icon(Icons.delete_outline)),
                                    )
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    )
                  // if (model.imageSelected != null &&
                  //     model.imageSelected!.path != "")
                  //   Expanded(
                  //     child: RotatedBox(
                  //       quarterTurns: 1,
                  //       child: Image.memory(model.img!
                  //           // model.imageSelected!.readAsBytesSync(),
                  //           ),
                  //     ),
                  //   ),
                  // if (model.labels.isNotEmpty)
                  //   Padding(
                  //     padding: const EdgeInsets.all(14.0),
                  //     child: Text(
                  //       model.labels.toString(),
                  //       textAlign: TextAlign.center,
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.bold,
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
          )),
        );
      },
      viewModelBuilder: () => FaceRecViewModel(),
    );
  }
}

class MyBottomSheet extends StatefulWidget {
  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  final _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: 'Enter the person name',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                final text = _textEditingController.text.trim();
                if (text.isNotEmpty) {
                  // widget.onSubmitted(text);
                  Navigator.pop(context, text);
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
