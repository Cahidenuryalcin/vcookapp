import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vcook_app/imagepicker.dart';
import 'package:vcook_app/drawerside.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vcook_app/kitchen.dart';
import 'package:vcook_app/service/food.dart';

class DetailPage extends StatefulWidget {
  final int index;

  DetailPage({required this.index});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late DocumentSnapshot foodSnapshot;
  bool _isFoodSnapshotLoaded = false;

  List<FoodIngredients> foodIngredients = [];


  @override
  void initState() {
    super.initState();
    fetchFoodDetails();
  }

  void fetchFoodDetails() async {
    var foodCollection = FirebaseFirestore.instance.collection('food');
    var foodIngredientsCollection =
        FirebaseFirestore.instance.collection('foodingredients');
    var querySnapshotFood =
        await foodCollection.where('id', isEqualTo: widget.index).get();

    // get ingredients by id and put in list
    var querySnapshotFoodIngredients = await foodIngredientsCollection
        .where('foodId', isEqualTo: widget.index)
        .get();

    // get ingredients by id and put in list
    for (var item in querySnapshotFoodIngredients.docs) {
      var ingredientsCollection =
          FirebaseFirestore.instance.collection('ingredients');
      var querySnapshotIngredients =
          await ingredientsCollection.where('id', isEqualTo: item['ingredientsId']).get();
      var ingredients = querySnapshotIngredients.docs.map((item) => Ingredients(
        id: item['id'],
        name: item['name'],
        categoryId: item['categoryId'],
        typeId: item['typeId'],
        type: item['type'],
      )).toList();
      foodIngredients.add(FoodIngredients(
        amount: item['amount'],
        foodId: item['foodId'],
        ingredientsId: item['ingredientsId'],
        ingredients: ingredients,
      ));
    }
    
    

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
                    "Malzemeler",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(
                      foodIngredients.length,
                          (index) => Row(
                        children: [
                          Text(
                            '•',
                            style: TextStyle(
                              fontSize: 20, // Madde işaretini burada büyütebilirsiniz
                              fontWeight: FontWeight.bold, // İsteğe bağlı olarak kalın yapabilirsiniz
                            ),
                          ),
                          SizedBox(width: 5), // Madde işareti ile metin arasında boşluk eklemek için
                          Text(
                            '${foodIngredients[index].amount} ${foodIngredients[index].ingredients.first.type} ${foodIngredients[index].ingredients.first.name}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16),
                  Text(
                    "Tarif",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(foodSnapshot['reciep']),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final userId = FirebaseAuth.instance.currentUser?.uid; // Aktif kullanıcının ID'sini al
                      if (userId != null) {
                        for (var ingredient in foodIngredients) {
                          var userIngredientDoc = await FirebaseFirestore.instance
                              .collection('useringredients')
                              .where('userId', isEqualTo: userId)
                              .where('ingredientsId', isEqualTo: ingredient.ingredientsId)
                              .get();

                          if (userIngredientDoc.docs.isNotEmpty) {
                            var userIngredientData = userIngredientDoc.docs.first;
                            var currentAmount = int.parse(userIngredientData['amount']);
                            var requiredAmount = int.parse(ingredient.amount);

                            var newAmount = max(currentAmount - requiredAmount, 0); // Yeni miktar, 0'dan küçükse 0 olacak

                            // Kullanıcı malzemesinin miktarını güncelle
                            await FirebaseFirestore.instance
                                .collection('useringredients')
                                .doc(userIngredientData.id)
                                .update({'amount': newAmount.toString()});

                            if (currentAmount < requiredAmount) {
                              // Malzeme miktarı yetersizse ve sıfırlanmışsa kullanıcıyı bilgilendir
                              Fluttertoast.showToast(msg: "${ingredient.ingredients.first.name} miktarı yetersiz. Malzeme miktarı sıfırlandı.");
                            }
                          }
                        }
                        // İşlem tamamlandı mesajı
                        Fluttertoast.showToast(msg: "Malzemeler güncellendi ve tarif başarıyla yapıldı!");
                      }
                    },
                    icon: Icon(Icons.check),
                    label: Text("Ben de Yaptım", style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),


                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImagePickerPage()),
                      );
                    },
                    icon: Icon(Icons.photo_camera),
                    label: Text("Ben de Yaptım Foto",
                        style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
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
