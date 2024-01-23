import 'package:cloud_firestore/cloud_firestore.dart';



class CategoriesFood {
  final int id;
  final String name;

  CategoriesFood({required this.id, required this.name});
}

class CategoriesIngredients {
  final int id;
  final String name;

  CategoriesIngredients({required this.id , required this.name});
}

class FoodIngredients {
  final String amount;
  final int foodId;
  final int ingredientsId;

  FoodIngredients({required this.amount, required this.foodId, required this.ingredientsId});
}

class Ingredients {
  final int id;
  final String name;
  final int categorydId;
  final int typeId;

  Ingredients({required this.id, required this.name, required this.categorydId,required this.typeId});
}
class Type {
  final int id;
  final String name;

  Type({required this.id, required this.name});

}


class IngredientRecieps {
  final int id;
  final String name;
  final String imagePath;
  final String category;
  final int categoryId;

  IngredientRecieps({required this.name, required this.imagePath, required this.category, required this.id , required this.categoryId});

}


class UserIngredients {
  final int id;
  final int userId;
  final int ingredientsId;
  final String amount;

  UserIngredients({required this.id, required this.userId, required this.ingredientsId, required this.amount});

}



class FoodService {
  // Function to fetch food categories
  Future<List<CategoriesFood>> fetchCategories(Map<String, String> categoriesMap) async {
    var foodcategoryCollection = FirebaseFirestore.instance.collection('categoriesfood');
    try {
      var querySnapshotCategory = await foodcategoryCollection.get();
      return querySnapshotCategory.docs.map((item) => CategoriesFood(
        id: item['id'],
        name: item['name'],
      )).toList();
    } catch (e) {
      // Handle errors or exceptions
      print('Error fetching categories: $e');
      return [];
    }
  }


  // Function to fetch ingredients categories
  Future<List<CategoriesIngredients>> fetchIngredientsCategories(Map<String, String> categoriesMap) async {
    var ingredientscategoryCollection = FirebaseFirestore.instance.collection('categoriesingredients');
    try {
      var querySnapshotCategory = await ingredientscategoryCollection.get();
      return querySnapshotCategory.docs.map((item) => CategoriesIngredients(
        id: item['id'],
        name: item['name'],
      )).toList();
    } catch (e) {
      // Handle errors or exceptions
      print('Error fetching categories: $e');
      return [];
    }
  }

  // Function to fetch foods
  Future<List<IngredientRecieps>> fetchFoods(Map<String, String> categoriesMap) async {
    var foodCollection = FirebaseFirestore.instance.collection('food');
    try {
      var querySnapshotFood = await foodCollection.get();
      return querySnapshotFood.docs.map((food) {
        String categoryId = food['categoryId'];
        String categoryName = categoriesMap[categoryId] ?? 'Unknown';
        return IngredientRecieps(
          id: food['id'],
          name: food['name'],
          imagePath: 'assets/images/${food['image']}',
          category: categoryName,
          categoryId: food['categoryId'],
        );
      }).toList();
    } catch (e) {
      // Handle errors or exceptions
      print('Error fetching foods: $e');
      return [];
    }
  }


  // Function to filter foods by category
  List<IngredientRecieps> filterFoodsByCategory(int categoryId, List<IngredientRecieps> allFoods) {
    return allFoods.where((ingredient) => ingredient.categoryId == categoryId).toList();
  }




}
