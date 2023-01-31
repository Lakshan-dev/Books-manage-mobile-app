import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uvatest/components/background.dart';

class Homepage extends StatefulWidget {
  final String uname;
  final String id;
  final String email;

  const Homepage({Key? key, required this.uname, required this.id, required this.email}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.blue,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 20.0),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
  );

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    // style
    var cardTextStyle = TextStyle(fontFamily: 'Montserrat Regular', fontSize: 18, color: Color.fromRGBO(63, 63, 63, 1));

    return Scaffold(
      body: Background(
        child: Stack(
          children: [
            Positioned(
              bottom: 30,
              right: 0,
              left: 0,
              child: Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 70,
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      height: 64,
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage('https://randomuser.me/api/portraits/men/15.jpg'),
                          ),
                          SizedBox(width: 16.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Text('${widget.uname}', style: TextStyle(color: Color.fromARGB(255, 6, 6, 6), fontFamily: "Aleo Bold", fontSize: 20.0),),
                              Text('${widget.id}', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontFamily: "Aleo Bold", fontSize: 18.0),),
                            ],
                          ),
                          SizedBox(width: 20.0),
                          Container(
                            // top: 4,
                            // right: 9,
                            child: GestureDetector(
                              onTap: () async{
                                SharedPreferences preferences = await SharedPreferences.getInstance();
                                  preferences.clear();
                                  Navigator.pushReplacementNamed(context, "/login");
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromARGB(255, 243, 243, 243),
                                ),
                                child: Icon(Icons.logout),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.count(
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        primary: false,
                        children: [
                          Card(
                            margin: EdgeInsets.only(top: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 8,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, '/addDamage');
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/damage-book.png', height: 90,),
                                  Text('Add Damage', style: TextStyle(fontSize: 18, color: Colors.black,)),
                                ],
                              ),
                            ), 
                          ),

                          Card(
                            margin: EdgeInsets.only(top: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)
                            ),
                            elevation: 8,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, '/damageBooks');
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/book_list.png', height: 90,),
                                  Text('Damaged', style: TextStyle(fontSize: 18, color: Colors.black,)),
                                ],
                              ),
                            ), 
                          ),

                          Card(
                            margin: EdgeInsets.only(top: 20,),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)
                            ),
                            elevation: 8,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, '/allBooks');
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/list-book.png', height: 90,),
                                  Text('Listed Books', style: TextStyle(fontSize: 18, color: Colors.black,)),
                                ],
                              ),
                            ), 
                          ),
                          
                        ],
                        crossAxisCount: 2,
                        ),
                    ),
                  ]
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}