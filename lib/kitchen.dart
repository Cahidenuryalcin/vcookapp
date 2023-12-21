import 'package:flutter/material.dart';
import 'package:vcook_app/constants.dart';
import 'package:vcook_app/data.dart';
import 'package:vcook_app/shared.dart';
import 'package:vcook_app/user.dart';
import 'package:vcook_app/drawerside.dart';


class Kitchen extends StatefulWidget {
  @override
  _KitchenState createState() =>_KitchenState();
}

class _KitchenState extends State<Kitchen> {

  List<bool> optionSelected = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerSide(),
      backgroundColor: Colors.grey[50],
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

                  buildTextTitleVariation1('Mobil Mutfağım'),

                  buildTextSubTitleVariation1('Mutfağınız, Mobil Mutfak ile Avcunuzun İçinde '),
                  buildTextSubTitleVariation1('Lezzetler Hep Sizinle'),

                  SizedBox(
                    height: 32,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      option('Sebze', 'assets/icons/salad.png', 0),
                      SizedBox(
                        width: 8,
                      ),
                      option('Bakliyat', 'assets/icons/rice.png', 1),
                      SizedBox(
                        width: 8,
                      ),
                      option('Meyve', 'assets/icons/fruit.png', 2),
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
                children: buildIngredients(),
              ),
            ),


            SizedBox(
              height: 16,
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

  List<Widget> buildIngredients(){
    List<Widget> list = [];
    for (var i = 0; i < getIngredients().length; i++) {
      list.add(buildIngredient(getIngredients()[i], i));
    }
    return list;
  }


  Widget buildIngredient(Ingredient ingredient, int index){
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          boxShadow: [kBoxShadow],
        ),
        margin: EdgeInsets.only(right: 8, left: index == 0 ? 8 : 0, bottom: 100, top: 8),
        padding: EdgeInsets.all(15),
        width: 193,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[


            SizedBox(
              height: 8,
            ),

            buildRecipeTitle(ingredient.title),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                buildCalories(ingredient.calories.toString() + " Gr"),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.add,
                )

              ],
            ),

          ],
        ),
      ),
    );
  }




}