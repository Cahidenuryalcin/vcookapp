import 'package:flutter/material.dart';
import 'package:vcook_app/user.dart';
import 'package:vcook_app/drawerside.dart';

class Kitchen extends StatefulWidget {
  @override
  _KitchenState createState() => _KitchenState();
}

class _KitchenState extends State<Kitchen> {
  List<bool> optionSelected = [true, false, false, false];

  // Kategori bilgileri
  final List<String> categories = ["İçecekler", "Bakliyatlar", "Unlu Mamüller", "Süt Ürünleri"];

  // Malzeme bilgileri
  final List<Ingredient> ingredients = [
    Ingredient(name: "Ekmek", quantity: 2),
    Ingredient(name: "Yumurta", quantity: 12),
    Ingredient(name: "Su", quantity: 5),
    Ingredient(name: "Nohut", quantity: 1),
    Ingredient(name: "Nohut", quantity: 1),
    Ingredient(name: "Nohut", quantity: 1),
    Ingredient(name: "Nohut", quantity: 1),
    Ingredient(name: "Nohut", quantity: 1),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: DrawerSide(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => User()));
              },
              child: Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Yeni malzeme ekleme işlevi
        },
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sanal Mutfağım',
                    style: TextStyle(
                      fontSize: 30, // Font boyutunu ayarlayın
                      fontWeight: FontWeight.bold, // Yazı tipi kalınlığını ayarlayın
                      color: Colors.black, // Yazı rengini ayarlayabilirsiniz
                    ),
                    textAlign: TextAlign.center, // Metni ortalamak için
                  ),

                  Text(
                    'Mutfağınız, Mobil Mutfak ile Avcunuzun İçinde',
                    style: TextStyle(
                      fontSize: 16, // Font boyutunu ayarlayın
                      color: Colors.black, // Yazı rengini ayarlayabilirsiniz
                    ),
                    textAlign: TextAlign.center, // Metni ortalamak için
                  ),

                  Text(
                    'Lezzetler Hep Sizinle',
                    style: TextStyle(
                      fontSize: 16, // Font boyutunu ayarlayın
                      color: Colors.black, // Yazı rengini ayarlayabilirsiniz
                    ),
                    textAlign: TextAlign.center, // Metni ortalamak için
                  ),
                  SizedBox(height: 32),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        categories.length,
                            (index) => option(categories[index], index),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                return buildIngredient(ingredients[index], index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget option(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          for (int i = 0; i < optionSelected.length; i++) {
            optionSelected[i] = i == index;
          }
        });
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: optionSelected[index] ? Colors.green : Colors.grey,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5, spreadRadius: 1)],
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          text,
          style: TextStyle(
            color: optionSelected[index] ? Colors.white : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildIngredient(Ingredient ingredient, int index) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(child: Text(ingredient.name)),
          ),
          Text("${ingredient.quantity} Gram"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Silme işlemi
                },
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Düzenleme işlemi
                  _showEditDialog(ingredient, context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Ingredient ingredient, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Miktar Düzenle'),
          content: TextField(
            controller: TextEditingController()..text = ingredient.quantity.toString(),
            decoration: InputDecoration(hintText: "Yeni miktar girin"),
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              child: Text('Kaydet'),
              onPressed: () {
                // Kaydetme işlemi
              },
            ),
          ],
        );
      },
    );
  }
}

class Ingredient {
  String name;
  int quantity;

  Ingredient({required this.name, required this.quantity});
}
