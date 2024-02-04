import 'package:flutter/material.dart';
import 'package:vcook_app/recieps.dart';
import 'package:vcook_app/service/auth.dart';
import 'package:vcook_app/user.dart';
import 'package:vcook_app/kitchen.dart';



class DrawerSide extends StatelessWidget {
  Widget listTile({ required IconData icon, required String title,required void  Function() onTap}){
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        size: 32,
        color: Colors.red,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  @override

  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white38,
        child: ListView(
          children: [
            DrawerHeader(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 43,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/icons/user.png'),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Mobil Mutfak", style: TextStyle(
                        fontSize: 23,
                      ),),
                      SizedBox(
                        height: 52,
                      ),
                    ],
                  )
                ],
              ),
            ),
            listTile(
                icon: Icons.person,
                title: "Profilim",
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => User(),
                    ),
                  );
             },
            ),
            listTile(
                icon: Icons.kitchen_outlined,
                title: "Sanal Mutfağım",
                onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Kitchen(),
                  ),
                );
              },
            ),
            listTile(
                icon: Icons.fastfood_outlined,
                title: "Yemek Tarifleri",
                onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Recieps(),
                  ),
                );
              },
            ),
            listTile(
                icon: Icons.favorite,
                title: "Favorilerim",
                onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => User(),
                  ),
                );
              },
            ),
            listTile(
                icon: Icons.keyboard_backspace_outlined,
                title: "Çıkış Yap",
                onTap: (){
                  Auth().signOut(context); // Çıkış yapma işlevini çağır//tıklanıldığında çıkış yapılacak ve homepage() sayfasına yönlendirilecek
              },
            ),
          ],
        ),
      ),
    );
  }
}




