import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vcook_app/recieps.dart';
import 'package:vcook_app/drawerside.dart';
import 'package:vcook_app/service/auth.dart';



class User extends StatelessWidget {

  final users = FirebaseAuth.instance.currentUser;

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
              users!.email!, // Replace with the user's name
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 80),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Saved Recipes page
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.greenAccent, // Yeşil renk
                minimumSize: Size(200, 50), // Genişlik ve yükseklik ayarı
              ),
              child: Text('Favori Tariflerim'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Auth().signOut(context); // Çıkış yapma işlevini çağır
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.pinkAccent,
                minimumSize: Size(200, 50),
              ),
              child: Text('Çıkış Yap'),
            ),
          ],
        ),
      ),
    );
  }
}

