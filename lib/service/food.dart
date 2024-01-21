import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vcook_app/detail.dart';



class FoodService {
  // Kategorileri çeken fonksiyon
  Future<Map<String, String>> fetchCategories() async {
    var categoryCollection = FirebaseFirestore.instance.collection('categoriesfood');
    var querySnapshotCategory = await categoryCollection.get();
    Map<String, String> categoriesMap = {};
    for (var category in querySnapshotCategory.docs) {
      categoriesMap[category.id] = category['name'];
    }
    return categoriesMap;
  }

  Future<List<Ingredient>> fetchFoods(Map<String, String> categoriesMap) async {
    var foodCollection = FirebaseFirestore.instance.collection('food');
    var querySnapshotFood = await foodCollection.get();
    List<Ingredient> foods = [];
    for (var food in querySnapshotFood.docs) {
      // category ID'sini kullanarak category ismini bul
      String categoryId = food['category'];
      String categoryName = categoriesMap[categoryId] ?? 'Unknown';
      foods.add(Ingredient(
        id: food['id'],
        name: food['name'],
        imagePath: 'assets/images/${food['image']}',
        category: categoryName,
      ));
    }
    return foods;
  }



  // Kategoriye göre yemekleri filtreleyen fonksiyon
  List<Ingredient> filterFoodsByCategory(String categoryName, List<Ingredient> allFoods) {
    return allFoods.where((ingredient) => ingredient.category == categoryName).toList();
  }
}
