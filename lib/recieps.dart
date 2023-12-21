import 'package:flutter/material.dart';
import 'package:vcook_app/constants.dart';
import 'package:vcook_app/data.dart';
import 'package:vcook_app/detail.dart';
import 'package:vcook_app/shared.dart';
import 'package:vcook_app/user.dart';
import 'package:vcook_app/drawerside.dart';

class Recieps extends StatefulWidget {

  @override
  _ReciepsState createState() => _ReciepsState();


}

class _ReciepsState extends State<Recieps> {

  List<bool> optionSelected = [true, false, false];

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

                  buildTextTitleVariation1('Yemek Tarifleri'),

                  buildTextSubTitleVariation1('Mutfağınız, Mobil Mutfak ile Avcunuzun İçinde '),
                  buildTextSubTitleVariation1('Lezzetler Hep Sizinle'),

                  SizedBox(
                    height: 32,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      option('Et Yemekleri', 'assets/icons/salad.png', 0),
                      SizedBox(
                        width: 8,
                      ),
                      option('Makarna', 'assets/icons/rice.png', 1),
                      SizedBox(
                        width: 8,
                      ),
                      option('Pr', 'assets/icons/fruit.png', 2),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 24,
            ),

            Container(
              height: 300,
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: buildRecipes(),
              ),
            ),


            SizedBox(
              height: 16,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [

                  buildTextTitleVariation2('Popüler', false),

                  SizedBox(
                    width: 8,
                  ),

                  buildTextTitleVariation2('Yemekler', true),

                ],
              ),
            ),

            Container(
              height: 190,
              child: PageView(
                physics: BouncingScrollPhysics(),
                children: buildPopulars(),
              ),
            ),

          ],
        ),

      ),
    );
  }


  Widget option(String text, String image, int index){
    return GestureDetector(
      onTap: () {
        setState(() {
          optionSelected[index] = !optionSelected[index];
        });
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: optionSelected[index] ? kPrimaryColor : Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          boxShadow: [kBoxShadow],
        ),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [

            SizedBox(
              height: 32,
              width: 32,
              child: Image.asset(
                image,
                color: optionSelected[index] ? Colors.white : Colors.black,
              ),
            ),

            SizedBox(
              width: 8,
            ),

            Text(
              text,
              style: TextStyle(
                color: optionSelected[index] ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildRecipes(){
    List<Widget> list = [];
    for (var i = 0; i < getIngredients().length; i++) {
      list.add(buildRecipe(getIngredients()[i], i));
    }
    return list;
  }


  Widget buildRecipe(Ingredient recipe, int index){
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Detail(ingredient: recipe)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          boxShadow: [kBoxShadow],
        ),
        margin: EdgeInsets.only(right: 8, left: index == 0 ? 8 : 0, bottom: 30, top: 8),
        padding: EdgeInsets.all(15),
        width: 193,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Expanded(
              child: Hero(
                tag: recipe.image,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(recipe.image),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 8,
            ),

            buildRecipeTitle(recipe.title),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                buildCalories(recipe.calories.toString() + " Kcal"),

                Icon(
                   Icons.favorite_border,
                )

              ],
            ),

          ],
        ),
      ),
    );
  }

  List<Widget> buildPopulars(){
    List<Widget> list = [];
    for (var i = 0; i < getIngredients().length; i++) {
      list.add(buildPopular(getIngredients()[i]));
    }
    return list;
  }

  Widget buildPopular(Ingredient recipe){
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        boxShadow: [kBoxShadow],
      ),
      child: Row(
        children: [

          Container(
            height: 160,
            width: 160,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(recipe.image),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  buildRecipeTitle(recipe.title),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      buildCalories(recipe.calories.toString() + " Kcal"),

                      Icon(
                        Icons.favorite_border,
                      )

                    ],
                  ),

                ],
              ),

            ),
          ),

        ],
      ),
    );
  }

}

