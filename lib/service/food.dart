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
  final List<Ingredients> ingredients;

  FoodIngredients({required this.amount, required this.foodId, required this.ingredientsId, required this.ingredients});
}

class Ingredients {
  final int id;
  final String name;
  final int categoryId;
  final int typeId;
  final String type;

  Ingredients({required this.id, required this.name, required this.categoryId,required this.typeId, required this.type});
}
class Type {
  final int id;
  final String name;

  Type({required this.id, required this.name});

}

class Ingredientsname {
  final String name;

  Ingredientsname({required this.name});
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

  final String userId;
  final int ingredientsId;
  late final String amount;

  UserIngredients({required this.userId, required this.ingredientsId, required this.amount});

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

  // if user is logged in, list of user ingredients
  Future<List<UserIngredients>> fetchUserIngredientsByUserId(int userId) async {
    var userIngredientsCollection = FirebaseFirestore.instance.collection('useringredients');
    try {
      var querySnapshotUserIngredients = await userIngredientsCollection.where('userId', isEqualTo: userId).get();
      return querySnapshotUserIngredients.docs.map((item) => UserIngredients(
        userId: item['userId'],
        ingredientsId: item['ingredientsId'],
        amount: item['amount'],
      )).toList();
    } catch (e) {
      // Handle errors or exceptions
      print('Error fetching ingredients: $e');
      return [];
    }
  }



  // Function to filter user ingredients by category
  List<UserIngredients> filterUserIngredientsByCategory(int categoryId, List<UserIngredients> allUserIngredients) {
    return allUserIngredients.where((ingredient) => ingredient.ingredientsId == categoryId).toList();
  }


  // Function to filter foods by category
  List<IngredientRecieps> filterFoodsByCategory(int categoryId, List<IngredientRecieps> allFoods) {
    return allFoods.where((ingredient) => ingredient.categoryId == categoryId).toList();
  }


  // make list of ingredients by food id
  Future<List<FoodIngredients>> fetchIngredientsByFoodId(int foodId) async {
    var foodIngredientsCollection = FirebaseFirestore.instance.collection('foodingredients');
    try {
      var querySnapshotFoodIngredients = await foodIngredientsCollection.where('foodId', isEqualTo: foodId).get();
      return querySnapshotFoodIngredients.docs.map((item) => FoodIngredients(
        amount: item['amount'],
        foodId: item['foodId'],
        ingredientsId: item['ingredientsId'],
        ingredients: [],
      )).toList();
    } catch (e) {
      // Handle errors or exceptions
      print('Error fetching ingredients: $e');
      return [];
    }
  }

  // get ingredients by id
  Future<List<Ingredients>> fetchIngredientsById(int ingredientsId) async {
    var ingredientsCollection = FirebaseFirestore.instance.collection('ingredients');
    try {
      var querySnapshotIngredients = await ingredientsCollection.where('id', isEqualTo: ingredientsId).get();
      return querySnapshotIngredients.docs.map((item) => Ingredients(
        id: item['id'],
        name: item['name'],
        categoryId: item['categoryId'],
        typeId: item['typeId'],
        type: item['type'],
      )).toList();
    } catch (e) {
      // Handle errors or exceptions
      print('Error fetching ingredients: $e');
      return [];
    }
  }






}
