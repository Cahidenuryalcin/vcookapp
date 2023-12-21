import 'package:flutter/material.dart';
import 'package:vcook_app/recieps.dart';
import 'package:vcook_app/drawerside.dart';



class User extends StatelessWidget {
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => Recieps()));
              },
              child: Icon(
                Icons.home,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/icons/user.png'), // Replace with the path to your profile image
            ),
            SizedBox(height: 50),
            Text(
              'Cahide Nur Yalçın', // Replace with the user's name
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'cahidenuryalcin@gmail.com', // Replace with the user's email
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 80),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Saved Recipes page
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Yeşil renk
                minimumSize: Size(200, 50), // Genişlik ve yükseklik ayarı
              ),
              child: Text('Favori Tariflerim'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement log out logic here
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent, // Yeşil renk
                minimumSize: Size(200, 50), // Genişlik ve yükseklik ayarı
              ),
              child: Text('Çıkış Yap'),
            ),
          ],
        ),
      ),
    );
  }
}
