import 'package:flutter/material.dart';
import 'package:vcook_app/camera.dart';
import 'package:vcook_app/imagepicker.dart';
import 'package:vcook_app/recieps.dart';
import 'package:vcook_app/drawerside.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vcook_app/service/food.dart'; // Burada 'path/to' kısmını uygun yola güncelleyin

class DetailPage extends StatefulWidget {
  final int index;

  DetailPage({required this.index});

  @override
  _DetailPageState createState() => _DetailPageState();
}
class _DetailPageState extends State<DetailPage> {
  late DocumentSnapshot foodSnapshot;
  bool _isFoodSnapshotLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchFoodDetails();
  }

  void fetchFoodDetails() async {
    var foodCollection = FirebaseFirestore.instance.collection('food');
    var querySnapshotFood =
    await foodCollection.where('id', isEqualTo: widget.index).get();
    if (querySnapshotFood.docs.isNotEmpty) {
      setState(() {
        foodSnapshot = querySnapshotFood.docs.first;
        _isFoodSnapshotLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isFoodSnapshotLoaded) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    String name = foodSnapshot['name'];
    String imagePath = 'assets/images/${foodSnapshot['image']}';
    String calorie = foodSnapshot['calorie'];
    String time = foodSnapshot['time'];
    String serving = foodSnapshot['service'];

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: DrawerSide(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Image.asset(
                    imagePath,
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildInfoCard('Kalori', '$calorie kcal'),
                      _buildInfoCard('Süre', '$time dk'),
                      _buildInfoCard('Servis', '$serving Kişilik'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Tarif",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(foodSnapshot['reciep']),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CameraOn()),
                      );
                    },
                    icon: Icon(Icons.photo_camera),
                    label: Text("Ben de Yaptım", style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ImagePickerPage()),
                      );
                    },
                    icon: Icon(Icons.photo_camera),
                    label: Text("Fotoğraf Yükle", style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(title),
            SizedBox(height: 4),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class Ingredient {
  int id;
  String name;
  String imagePath;
  String category;


  Ingredient({required this.name, required this.imagePath, required this.category, required this.id});

}
