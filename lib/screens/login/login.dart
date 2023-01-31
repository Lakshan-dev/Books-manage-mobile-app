import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uvatest/components/background.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;

import '../home_page.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {

    final _formKey = GlobalKey<FormState>();
    late String email, password;
    bool isLoading=false;

    final idController = TextEditingController();
    final passwordController = TextEditingController();

    GlobalKey<ScaffoldState>_scaffoldKey=GlobalKey();
    late ScaffoldMessengerState scaffoldMessenger ;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      key: _scaffoldKey,
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Image.asset(
                "assets/images/logo.png",
                height: 100,
              ),
            ),

            SizedBox(height: size.height * 0.03,),

            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "LOGIN",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 89, 89, 89),
                  fontSize: 36
                ),
                textAlign: TextAlign.right,
              ),
            ),

            SizedBox(height: size.height * 0.03,),

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: "Email",
                ),
                onSaved: (val) {
                  email = val!;
                },
              ),
            ),

            SizedBox(height: size.height * 0.03,),

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                ),
                obscureText: true,
                onSaved: (val) {
                  email = val!;
                },
              ),
            ),

            SizedBox(height: size.height * 0.03,),

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: RaisedButton(
                onPressed: (() {
                  if (isLoading) {
                    return;
                  }
                  if (idController.text.isEmpty || passwordController.text.isEmpty) {
                    scaffoldMessenger.showSnackBar(SnackBar(content: Text("Please fill all the fields!")));
                    return;
                  }
                  login(idController.text, passwordController.text);
                  setState(() {
                    isLoading = true;
                  });
                }),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                textColor: Colors.white,
                padding: const EdgeInsets.all(0),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: size.width * 0.3,
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(80.0),
                    gradient: new LinearGradient(colors: [Color.fromARGB(255, 25, 0, 255), Color.fromARGB(255, 255, 208, 0)]),
                  ),
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    "LOGIN",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: (isLoading)?Center(
                child: Container(
                  height:26,
                  width: 26,
                  child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
                  )
                )
              ):Container(),
              // right: 30,
              // bottom: 0,
              // top: 0,
            )
          ],
        ) 
      ),
    );
  }

  login(email,password)async{
    Map data = {
      'email':email,
      'password':password
    };

    print(data.toString());

    final response = await http.post(Uri.parse("http://uvalms.ru.com/mobile_app/login.php"), 
      headers: {"Accept":"application/json"},
      body: json.encode(data),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      print(response.body);
      // Map<String,dynamic>resposne=jsonDecode(response.body);
      var resposne=jsonDecode(response.body);
      if (!resposne['error']) {
        Map<String,dynamic>user=resposne['data'];
        print(" User name ${user['name']}");
        savePref(1,user['name'],user['email'],user['admin_id']);

        // Navigate to Home Screen
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Homepage(uname:user['name'], id: user['admin_id'], email: user['email'],)));
        // Navigator.pushNamed(context, '/home');
      }else{
        print(" ${resposne['message']}");
      }
      scaffoldMessenger.showSnackBar(SnackBar(content:Text("${resposne['message']}")));
      
    }else{
      scaffoldMessenger.showSnackBar(SnackBar(content:Text("Please try again!")));
    }
  }

  savePref(int value, String name, String email, String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

      preferences.setInt("value", value);
      preferences.setString("name", name);
      preferences.setString("email", email);
      // preferences.setString("id", id.toString());
      preferences.setString("id", id);
      preferences.commit();

  }
}