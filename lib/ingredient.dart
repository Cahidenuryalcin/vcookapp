class Ingredient{

  String title;
  int quantity;

  Ingredient(this.title, this.quantity);

}

List<Ingredient> getIngredient(){
  return <Ingredient>[
    Ingredient("Süt", 1000),
    Ingredient("Un", 1000),

  ];
}