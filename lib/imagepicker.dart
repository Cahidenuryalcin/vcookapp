
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';


class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  XFile? _image;
  List? _prediction;
  late ObjectDetector objectDetector ;
  var image;

  @override
  void initState() {
    super.initState();
    // loadModel();
    // final options = ObjectDetectorOptions(mode: DetectionMode.single, classifyObjects: true, multipleObjects: true);
    // objectDetector = ObjectDetector(options: options);
    loadmodel();
  }

  loadmodel() async {
    final modelPath = await getModelPath('assets/ml/model_metadata.tflite');
    final options = LocalObjectDetectorOptions(
      mode: DetectionMode.single,
      modelPath: modelPath,
      classifyObjects: true,
      multipleObjects: true,
    );
    objectDetector = ObjectDetector(options: options);
  }


  Future<String> getModelPath(String asset) async {
    final path = '${(await getApplicationSupportDirectory()).path}/$asset';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(asset);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_metadata.tflite',
      labels: 'assets/labels.txt',

    );
  }


  detect_image(File image) async {
    var prediction = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.8,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _prediction = prediction;
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Future getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = image;
        detect_image(File(_image!.path));
        doObjectDetection();
      });
    }
  }



  getCameraImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _image = image;
        detect_image(File(_image!.path));
        doObjectDetection();
      });
    }
  }

  List<DetectedObject> objects = [];
  doObjectDetection() async {
    InputImage inputImage = InputImage.fromFilePath(_image!.path);
    objects = await objectDetector.processImage(inputImage);

    for(DetectedObject detectedObject in objects){
      final rect = detectedObject.boundingBox;
      final trackingId = detectedObject.trackingId;

      for(Label label in detectedObject.labels){
        print('${label.text} ${label.confidence}');
      }
    }

    setState(() {
      _image = _image;
    });

    drawRectanglesAroundObjects();
  }

  //TODO draw rectangles
  drawRectanglesAroundObjects() async {
    image = await _image?.readAsBytes();
    image = await decodeImageFromList(image);
    setState(() {
      image;
      objects;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Galeriden Fotoğraf Seç ve Tanı'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (_image == null) Text('Henüz bir fotoğraf seçilmedi.') else Center(
                    child: FittedBox(
                    child: SizedBox(
                      width: image.width.toDouble(),
                    height: image.width.toDouble(),
                    child: CustomPaint(
                      painter: ObjectPainter(
                          objectList: objects, imageFile: image),
                    ),
                  ),
                ),
                )
            ],
     ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed:() {
          getImage();
        }, onLongPress: (){
        getCameraImage();
      }, child: Icon(Icons.add_a_photo),
      ),
    );
  }
}


class ObjectPainter extends CustomPainter {
  List<DetectedObject> objectList;
  dynamic imageFile;
  ObjectPainter({required this.objectList, @required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }
    Paint p = Paint();
    p.color = Colors.red;
    p.style = PaintingStyle.stroke;
    p.strokeWidth = 4;

    for (DetectedObject rectangle in objectList) {
      canvas.drawRect(rectangle.boundingBox, p);
      var list = rectangle.labels;
      for(Label label in list){
        print("${label.text}   ${label.confidence.toStringAsFixed(2)}");
        TextSpan span = TextSpan(text: label.text,style: const TextStyle(fontSize: 25,color: Colors.blue));
        TextPainter tp = TextPainter(text: span, textAlign: TextAlign.left,textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, Offset(rectangle.boundingBox.left,rectangle.boundingBox.top));
        break;
      }
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

