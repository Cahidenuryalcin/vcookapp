import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  XFile? _image;
  String _foodMessage = "";

  @override
  void initState() {
    super.initState();
    loadModel().then((val) {});
  }

  Future loadModel() async {
    var result = await Tflite.loadModel(
      model: "assets/ssd_mobilenet.tflite",
      labels: "assets/ssd_mobilenet.txt",
    );
    print("Model yüklendi: $result");
  }

  Future getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      recognizeImage(File(image.path));
    }

    setState(() {
      _image = image;
    });
  }

  Future recognizeImage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 5,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    if (recognitions != null) {
      bool isFoodDetected = recognitions.any((res) => isFood(res["label"]));
      setState(() {
        _foodMessage = isFoodDetected ? "Yemek tanındı!" : "Yemek tanınmadı.";
      });
    } else {
      setState(() {
        _foodMessage = "Tanınan bir nesne bulunamadı.";
      });
    }
  }

  bool isFood(String label) {
    return ["apple", "banana"].contains(label.toLowerCase());
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Galeriden Fotoğraf Seç ve Tanı'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('Henüz bir fotoğraf seçilmedi.')
                : Column(
              children: <Widget>[
                Image.file(File(_image!.path)),
                SizedBox(height: 20),
                Text(
                  _foodMessage,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Fotoğraf Seç',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}