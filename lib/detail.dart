import 'package:flutter/material.dart';
import 'package:vcook_app/constants.dart';
import 'package:vcook_app/shared.dart';
import 'package:vcook_app/data.dart';

class Detail extends StatelessWidget {

  final Ingredient ingredient;

  Detail({required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.favorite_border,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  buildTextTitleVariation1(ingredient.title),


                ],
              ),
            ),

            SizedBox(
              height: 16,
            ),

            Container(
              height: 310,
              padding: EdgeInsets.only(left: 16),
              child: Stack(
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      buildTextTitleVariation2('Besin Değerleri', false),

                      SizedBox(
                        height: 16,
                      ),

                      buildNutrition(ingredient.calories, "Kalori", "Kcal"),

                      SizedBox(
                        height: 16,
                      ),

                      buildNutrition(ingredient.carbo, "Süre", "Dakika"),

                      SizedBox(
                        height: 16,
                      ),

                      buildNutrition(ingredient.protein, "Servis", "Kişi"),

                    ],
                  ),

                  Positioned(
                    right: -80,
                    child: Hero(
                      tag: ingredient.image,
                      child: Container(
                        height: 310,
                        width: 310,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(ingredient.image),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  buildTextTitleVariation2('Malzemeler', false),

                  buildTextSubTitleVariation1("500gr Tavuk Bonfile"),
                  buildTextSubTitleVariation1("10gr Yoğurt"),
                  buildTextSubTitleVariation1("2gr Karabiber"),
                  buildTextSubTitleVariation1("2gr Tuz"),
                  buildTextSubTitleVariation1("10gr Yağ"),
                  buildTextSubTitleVariation1("5gr Bal"),

                  SizedBox(height: 16,),

                  buildTextTitleVariation2('Tarif', false),

                  buildTextSubTitleVariation1("Tavuğu iki eş parçaya böl, bir çalat yardımıyla ez, tüm malzemeleri tavukla buluştur. 1 saat buzdolabında dinlendir."),
                  buildTextSubTitleVariation1("Dinlenmiş tavuğu tavaya yağ ekleyerek pişir, yaklaşık yarım saat kısık ateşte pişmiş tavuğa bal ekle ve ocağın altını kapat"),
                  buildTextSubTitleVariation1("15 dakika dinlendirilmiş yemeği servis edebilirsin. Afiyet olsun!"),

                ],
              ),
            ),

          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: kPrimaryColor,
          icon: Icon(
            Icons.image,
            color: Colors.white,
            size: 32,
          ),
          label: Text(
            "Yemeği Yükle",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          )
      ),
    );
  }

  Widget buildNutrition(int value, String title, String subTitle){
    return Container(
      height: 60,
      width: 150,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        boxShadow: [kBoxShadow],
      ),
      child: Row(
        children: [

          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [kBoxShadow],
            ),
            child: Center(
              child: Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(
            width: 20,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                subTitle,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[400],
                ),
              ),

            ],
          ),

        ],
      ),
    );
  }

}