import 'package:flutter/material.dart';
import 'package:vcook_app/service/auth.dart';

class LoginPage extends StatelessWidget {
  @override
  final _tEmail = TextEditingController();
  final _tPassword = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.black,),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("Giriş", style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold
                      ),),
                      SizedBox(height: 20,),
                      Text("Sanal Mutfağınıza Giriş Yapın", style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700]
                      ),),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        makeInput(label: "Email", controller: _tEmail),
                        makeInput(label: "Şifre", controller: _tPassword, obscureText: true), // Şifre alanı için güncelleme
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border(
                            bottom: BorderSide(color: Colors.black),
                            top: BorderSide(color: Colors.black),
                            left: BorderSide(color: Colors.black),
                            right: BorderSide(color: Colors.black),
                          )
                      ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {
                          Auth().signIn(context, email: _tEmail.text, password: _tPassword.text);
                        },
                        color: Colors.greenAccent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: Text("Giriş Yap", style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18
                        ),),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Hesabınız yok mu?"),
                      Text("Kayıt Ol", style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18
                      ),),
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background.png'),
                      fit: BoxFit.cover
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget makeInput({required TextEditingController controller, required String label, bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87
        ),),
        SizedBox(height: 8,),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(),
            border: OutlineInputBorder(),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => controller.clear(),
            )
                : null,
          ),
        ),
        SizedBox(height: 10,),
      ],
    );
  }

}
