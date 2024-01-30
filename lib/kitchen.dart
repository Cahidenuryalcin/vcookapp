import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vcook_app/service/food.dart';
import 'package:vcook_app/drawerside.dart';

class Kitchen extends StatefulWidget {
  @override
  _KitchenState createState() => _KitchenState();
}

class _KitchenState extends State<Kitchen> {
  String? uid;

  List<bool> optionSelected = [];
  List<CategoriesIngredients> categoriesingredients = [];
  List<CategoriesIngredients> displayedCategories = [];

  List<UserIngredients> useringredients = [];
  List<UserIngredients> displayedIngredients = [];

  Map<String, int> ingredientNameToIdMap = {};

  List<bool> dropdownSelected = [];
  List<String> dropdownOptions = [];
  String? dropdownValue;

  TextEditingController adetController = TextEditingController();

  @override
  void dispose() {
    adetController.dispose();
    super.dispose();
  }

  void setCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uid = user.uid;
      print(uid);
    }
  }

  Future<void> addDataToFirebase() async {
    int? ingredientId = ingredientNameToIdMap[dropdownValue];
    if (ingredientId != null && uid != null) {
      await FirebaseFirestore.instance.collection('useringredients').add({
        'ingredientsId': ingredientId,
        'amount': adetController.text,
        'userId': uid,
      });
      fetchUserIngredientsAndCategories(); // Malzeme listesini yeniden yükle
      setState(() {
        dropdownValue = null; // Dropdown değerini sıfırla
      });
      fetchIngredientNames(); // Malzeme isimlerini yeniden yükle
    } else {
      print("Selected ingredient ID not found or user is not logged in");
    }
  }


  Future<void> updateIngredient(
      UserIngredients ingredient, String newAmount) async {
    try {
      await FirebaseFirestore.instance
          .collection('useringredients')
          .where('userId', isEqualTo: ingredient.userId)
          .where('ingredientsId', isEqualTo: ingredient.ingredientsId)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.update({'amount': newAmount}); // Update the document
        }
      });

      // Update the local list and UI
      setState(() {
        ingredient.amount = newAmount; // Update local data
        displayedIngredients = List.from(useringredients);
      });

    } catch (e) {
      print("Error updating ingredient: $e");
      // Optionally, show an error message to the user
    }
  }

  @override
  void initState() {
    super.initState();
    setCurrentUser();
    fetchUserIngredientsAndCategories();
    fetchIngredientNames();
  }

  void fetchUserIngredientsAndCategories() async {
    // fetch user ingredients
    if (uid != null) {
      var userIngredientsCollection =
          FirebaseFirestore.instance.collection('useringredients');
      var querySnapshotUserIngredients =
          await userIngredientsCollection.where('userId', isEqualTo: uid).get();
      List<UserIngredients> tempUserIngredients = [];
      for (var item in querySnapshotUserIngredients.docs) {
        tempUserIngredients.add(UserIngredients(
          userId: item['userId'],
          ingredientsId: item['ingredientsId'],
          amount: item['amount'],
        ));
      }
      setState(() {
        useringredients = tempUserIngredients;
        displayedIngredients = List.from(useringredients);
      });
    }

    var ingredientsCategoryCollection =
        FirebaseFirestore.instance.collection('categoriesingredients');
    try {
      var querySnapshotCategory = await ingredientsCategoryCollection.get();
      var fetchedCategories = querySnapshotCategory.docs
          .map((item) => CategoriesIngredients(
                id: item.data()['id'],
                name: item.data()['name'],
              ))
          .toList();

      setState(() {
        categoriesingredients = fetchedCategories;
        optionSelected =
            List.generate(categoriesingredients.length, (index) => false);
      });
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<Map<String, String>> getIngredientById(int id) async {
    var ingredientsCollection =
        FirebaseFirestore.instance.collection('ingredients');
    var querySnapshotIngredients =
        await ingredientsCollection.where('id', isEqualTo: id).get();
    if (querySnapshotIngredients.docs.isNotEmpty) {
      var data = querySnapshotIngredients.docs.first.data();
      return {
        'name': data['name'] ?? 'Unknown',
        'type': data['type'] ?? 'Unknown'
      };
    }
    return {'name': 'Unknown', 'type': 'Unknown'};
  }

  Future<void> deleteIngredient(UserIngredients ingredient) async {
    try {
      // Assuming you have a unique identifier for each ingredient, such as ingredientsId
      await FirebaseFirestore.instance
          .collection('useringredients')
          .where('userId', isEqualTo: ingredient.userId)
          .where('ingredientsId', isEqualTo: ingredient.ingredientsId)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete(); // Delete the document
        }
      });
      fetchUserIngredientsAndCategories(); // Malzemeyi sildikten sonra malzeme isimlerini güncelleyin
      // Update the local list and UI
      setState(() {
        useringredients.remove(ingredient);
        displayedIngredients = List.from(useringredients);
      });
      fetchIngredientNames(); // Malzeme isimlerini yeniden yükle
    } catch (e) {
      print("Error deleting ingredient: $e");
      // Optionally, show an error message to the user
    }
  }

  // Function to fetch ingredient names
  void fetchIngredientNames() async {
    var ingredientsCollection = FirebaseFirestore.instance.collection('ingredients');
    try {
      var querySnapshot = await ingredientsCollection.get();
      Map<String, int> tempMap = {};
      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        // Eğer malzeme kullanıcının malzemeleri arasında yoksa, dropdown menüsüne ekle
        if (!useringredients.any((ingredient) => ingredient.ingredientsId == data['id'])) {
          tempMap[data['name']] = data['id'];
        }
      }
      setState(() {
        ingredientNameToIdMap = tempMap;
        dropdownOptions = ingredientNameToIdMap.keys.toList(); // Update dropdown options
      });
    } catch (e) {
      print('Error fetching ingredient names: $e');
    }
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Kitchen()));
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
                        Text('Malzeme Ekle',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
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
                          items: dropdownOptions
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          style: TextStyle(color: Colors.black),
                          icon:
                              Icon(Icons.arrow_drop_down, color: Colors.black),
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
                          controller: adetController,
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
                          addDataToFirebase();
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
                      fontSize: 30,
                      // Font boyutunu ayarlayın
                      fontWeight: FontWeight.bold,
                      // Yazı tipi kalınlığını ayarlayın
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
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('useringredients')
                  .where('userId', isEqualTo: uid)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Hata: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                // Kullanıcının malzemelerini kontrol et
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  // Kullanıcının hiç malzemesi yoksa bir mesaj göster
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Sanal Mutfağınızda hiç malzeme yok. Malzeme eklemek için "+" butonuna tıklayın.',
                      style: TextStyle(fontSize: 27.0, color: Colors.green, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontFamily: 'Open Sans'),
                    ),
                  );
                }

                // Kullanıcı malzemelerini listele
                List<UserIngredients> userIngredients = snapshot.data!.docs
                    .map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  return UserIngredients(
                    userId: data['userId'],
                    ingredientsId: data['ingredientsId'],
                    amount: data['amount'],
                  );
                }).toList();
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: userIngredients.length,
                  itemBuilder: (context, index) {
                    return buildIngredient(userIngredients[index], index);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget option(CategoriesIngredients category, int index) {
    // Update parameter type
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
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 5, spreadRadius: 1)
          ],
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
    String ingredientName = ''; // Malzemenin adını saklamak için bir değişken

    return InkWell(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder<Map<String, String>>(
                  future: getIngredientById(ingredient.ingredientsId),
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String, String>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading...", textAlign: TextAlign.center);
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}",
                          textAlign: TextAlign.center);
                    } else {
                      ingredientName = snapshot.data?['name'] ??
                          'Unknown'; // Update the ingredient name
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            ingredientName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${ingredient.amount} ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${snapshot.data?['type'] ?? 'Unknown'}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () => deleteIngredient(ingredient),
                      child: Icon(Icons.delete, color: Colors.red),
                    ),
                    InkWell(
                      onTap: () {
                        TextEditingController newAmountController =
                            TextEditingController(text: ingredient.amount);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text('Malzeme Güncelle',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              content: TextFormField(
                                controller: newAmountController,
                                decoration: InputDecoration(
                                  labelText: 'Yeni Adet',
                                  labelStyle: TextStyle(color: Colors.blue),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                ),
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
                                    updateIngredient(
                                        ingredient, newAmountController.text);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Icon(Icons.edit, color: Colors.blue),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
