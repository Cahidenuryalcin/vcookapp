import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vcook_app/detail.dart';
import 'package:vcook_app/drawerside.dart';
import 'package:vcook_app/user.dart';


class Recieps extends StatefulWidget {
  @override
  _ReciepsState createState() => _ReciepsState();
}

class _ReciepsState extends State<Recieps> {
  List<bool> optionSelected = [];
  List<String> categories = [];
  List<Ingredient> ingredients = [];
  List<Ingredient> displayedIngredients = [];

  @override
  void initState() {
    super.initState();
    fetchCategoriesAndIngredients();
  }

  void fetchCategoriesAndIngredients() async {
    var categoryCollection = FirebaseFirestore.instance.collection('categoriesfood');
    var querySnapshotCategory = await categoryCollection.get();
    Map<String, String> categoriesMap = {};
    for (var category in querySnapshotCategory.docs) {
      categoriesMap[category.id] = category['name'];
    }

    var foodCollection = FirebaseFirestore.instance.collection('food');
    var querySnapshotFood = await foodCollection.get();
    List<Ingredient> tempIngredients = [];
    for (var food in querySnapshotFood.docs) {
      String categoryName = categoriesMap[food['category']] ?? 'Unknown';
      tempIngredients.add(Ingredient(
        id: food['id'],
        name: food['name'],
        imagePath: 'assets/images/${food['image']}',
        category: categoryName,
      ));
    }

    setState(() {
      categories = categoriesMap.values.toList();
      ingredients = tempIngredients;
      displayedIngredients = List.from(ingredients);
      optionSelected = List.generate(categories.length, (index) => false);
    });
  }

  void filterIngredientsByCategory(String categoryName) {
    var filteredIngredients = ingredients.where((ingredient) => ingredient.category == categoryName).toList();

    setState(() {
      displayedIngredients = filteredIngredients;
    });
  }


  void resetFilters() {
    setState(() {
      displayedIngredients = List.from(ingredients);
    });
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
                    'Yemek Tarifleri',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Mutfağınız, Mobil Mutfak ile Avcunuzun İçinde',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Lezzetler Hep Sizinle',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
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
              itemCount: displayedIngredients.length,
              itemBuilder: (context, index) {
                print(displayedIngredients);
                return buildIngredient(displayedIngredients[index], index);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget option(String categoryName, int index) {
    return GestureDetector(
      onTap: () {
        if (optionSelected[index]) {
          resetFilters();
          optionSelected[index] = false;
        } else {
          for (int i = 0; i < optionSelected.length; i++) {
            optionSelected[i] = false;
          }
          optionSelected[index] = true;
          filterIngredientsByCategory(categoryName);
        }

        setState(() {});
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
          categoryName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildIngredient(Ingredient ingredient, int index) {
    print(ingredient.id);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(

            builder: (context) => DetailPage(index: ingredient.id),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(ingredient.imagePath, fit: BoxFit.cover),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ingredient.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.favorite_border, color: Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

