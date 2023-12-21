class Ingredient {

  String title;

  String image;
  int calories;
  int carbo;
  int protein;

  Ingredient(this.title, this.image, this.calories, this.carbo, this.protein);

}

List<Ingredient> getIngredients(){
  return <Ingredient>[
    Ingredient("Izgara Tavuk",  "assets/images/chicken_fried_rice.png", 450, 45, 3),
    Ingredient("Salçalı Makarna",  "assets/images/pasta_bolognese.png", 200, 45, 10),
    Ingredient("Sarımsaklı Biftek", "assets/images/filete_con_papas_cambray.png", 150, 30, 8),
    Ingredient("Kuşkonmaz Somon", "assets/images/asparagus.png", 190, 35, 12),
    Ingredient("Kumpir", "assets/images/steak_bacon.png", 250, 55, 20),
  ];
}