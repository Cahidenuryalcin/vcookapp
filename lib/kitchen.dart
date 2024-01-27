import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vcook_app/service/food.dart';
import 'package:vcook_app/user.dart';
import 'package:vcook_app/drawerside.dart';


class Kitchen extends StatefulWidget {
  @override
  _KitchenState createState() => _KitchenState();
}

class _KitchenState extends State<Kitchen> {
  List<bool> optionSelected = [];
  List<CategoriesIngredients> categoriesingredients = [];
  List<CategoriesIngredients> displayedCategories = [];

  List<UserIngredients> useringredients = [];
  List<UserIngredients> displayedIngredients = [];



  List<bool> dropdownSelected = [];
  List<String> dropdownOptions = ['Seçenek 1', 'Seçenek 2', 'Seçenek 3'];
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    fetchUserIngredientsAndCategories();
  }



  void fetchUserIngredientsAndCategories() async {
    var ingredientsCategoryCollection = FirebaseFirestore.instance.collection('categoriesingredients');
    try {
      var querySnapshotCategory = await ingredientsCategoryCollection.get();
      var fetchedCategories = querySnapshotCategory.docs.map((item) => CategoriesIngredients(
        id: item.data()['id'],
        name: item.data()['name'],
      )).toList();

      setState(() {
        categoriesingredients = fetchedCategories;
        optionSelected = List.generate(categoriesingredients.length, (index) => false);
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }



    var userIngredientsCollection = FirebaseFirestore.instance.collection('useringredients');
    
    
    var querySnapshotUserIngredients = await userIngredientsCollection.where('userId', isEqualTo: 1).get();

    List<UserIngredients> tempIngredients = [];
    for (var useringredient in querySnapshotUserIngredients.docs) {
      print( useringredient['userId']);
      tempIngredients.add(UserIngredients(
        userId: useringredient['userId'],
        ingredientsId: useringredient['ingredientsId'],
        amount: useringredient['amount'],
      ));
    }


    setState(() {
      useringredients = tempIngredients;
      displayedIngredients = List.from(useringredients);
    });



  }

  Future<Map<String, String>> getIngredientById(int id) async {
    var ingredientsCollection = FirebaseFirestore.instance.collection('ingredients');
    var querySnapshotIngredients = await ingredientsCollection.where('id', isEqualTo: id).get();
    if (querySnapshotIngredients.docs.isNotEmpty) {
      var data = querySnapshotIngredients.docs.first.data();
      return {
        'name': data['name'] ?? 'Unknown',
        'type': data['type'] ?? 'Unknown'
      };
    }
    return {'name': 'Unknown', 'type': 'Unknown'};
  }




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
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: Row(
                      children: [
                        Icon(Icons.add_box, color: Colors.green),
                        SizedBox(width: 8),
                        Text('Malzeme Ekle', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton<String>(
                          value: dropdownValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          items: dropdownOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          style: TextStyle(color: Colors.black),
                          icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                          elevation: 2,
                          isExpanded: true,
                          underline: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                          dropdownColor: Colors.white,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Adet',
                            labelStyle: TextStyle(color: Colors.green),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          //    controller: adetController,
                        ),
                      ],
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
                          // Burada kaydetme işlemini yapabilirsiniz.
                          String selectedOption = dropdownValue ?? '';
                          //   int adet = int.tryParse(adetController.text) ?? 0;
                          // Yapılacak işlemleri ekleyin
                          // Ardından pencereyi kapatmak için Navigator.of(context).pop() kullanabilirsiniz.
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );

        },
        child: const Icon(Icons.add),

        backgroundColor: Colors.green,
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
                        categoriesingredients.length,
                            (index) => option(categoriesingredients[index], index),
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
              itemCount: displayedIngredients.length,
              itemBuilder: (context, index) {
                 return buildIngredient(displayedIngredients[index], index);
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget option(CategoriesIngredients category, int index) { // Update parameter type
    return GestureDetector(
      onTap: () {
        setState(() {
          for (int i = 0; i < optionSelected.length; i++) {
            optionSelected[i] = i == index;
          }
          // TODO: You may want to filter ingredients based on the selected category
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
          category.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildIngredient(UserIngredients ingredient, int index) {
    print(ingredient);
    return InkWell(
      child: Card(
        margin: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ingredient.amount,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  FutureBuilder<Map<String, String>>(
                    future: getIngredientById(ingredient.ingredientsId),
                    builder: (BuildContext context, AsyncSnapshot<Map<String, String>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading...");
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        return Text(
                          "${snapshot.data?['name'] ?? 'Unknown'} (${snapshot.data?['type'] ?? 'Unknown'})",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        );
                      }
                    },
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

