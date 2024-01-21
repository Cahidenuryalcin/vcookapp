import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vcook_app/service/auth.dart';

class SignupPage extends StatelessWidget {
  @override
  final _tName = TextEditingController();
  final _tEmail = TextEditingController();
  final _tPassword = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("Kayıt ", style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 20,),
                  Text("Sanal Mutfağınızı Oluşturun", style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700]
                  ),),
                ],
              ),
              Column(
                children: <Widget>[
                  makeInput(label: "İsim", controller: _tName, obscureText: false),
                  makeInput(label: "Email", controller: _tEmail, obscureText: false),
                  makeInput(label: "Şifre", controller: _tPassword, obscureText: true),
                ],
              ),
              Container(
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
                    if (EmailValidator.validate(_tEmail.text)) {
                      Auth().signUp(context, name: _tName.text, email: _tEmail.text, password: _tPassword.text);
                    } else {
                      Fluttertoast.showToast(msg: "Geçersiz email adresi", toastLength: Toast.LENGTH_LONG);
                    }
                  },
                  color: Colors.greenAccent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                  ),
                  child: Text("Kayıt Ol",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Zaten hesabınız var mı?"),
                  Text(" Giriş Yap", style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 18
                  ),),
                ],
              ),
            ],
          ),
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
