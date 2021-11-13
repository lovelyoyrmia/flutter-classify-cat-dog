import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  File _image;
  List _output;
  final picker = ImagePicker();

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: 'assets/images/model_unquant.tflite',
      labels: 'assets/images/labels.txt',
    );
  }

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future detectImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output;
      isLoading = false;
    });
  }

  Future pickCameraImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    detectImage(_image);
  }

  Future pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });
    detectImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Text(
              'AI App',
              style: TextStyle(
                fontSize: 20,
                color: Colors.amberAccent,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Detect Cat and Dog',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 350,
              child: Column(
                children: [
                  Center(
                    child: isLoading
                        ? Column(
                            children: [
                              Container(
                                width: 200,
                                child: Image.asset('assets/images/dog.webp'),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: 200,
                                child: Image.asset('assets/images/cat.webp'),
                              )
                            ],
                          )
                        : Container(
                            child: Column(
                              children: [
                                Container(
                                  height: 250,
                                  child: Image.file(_image),
                                ),
                                SizedBox(height: 40),
                                _output != null
                                    ? Text(
                                        'it is a ${_output[0]['label']}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Container(
                                        width: 250,
                                        child: Text(
                                          'Neither cat nor dog',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                  ),
                  SizedBox(height: 40),
                  FloatingActionButton.extended(
                    onPressed: () async {
                      pickCameraImage();
                    },
                    label: Text('Click a photo'),
                    backgroundColor: Colors.green,
                  ),
                  SizedBox(height: 40),
                  FloatingActionButton.extended(
                    onPressed: () async {
                      pickGalleryImage();
                    },
                    label: Text('Select a photo'),
                    backgroundColor: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
