// import 'dart:html';

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:uvatest/components/background.dart';
import 'package:uvatest/components/custom_tab_indicator.dart';

import 'package:http/http.dart' as http;


class damagedBooksView extends StatefulWidget {
  const damagedBooksView({Key? key}) : super(key: key);

  @override
  State<damagedBooksView> createState() => _bookViewState();
}

class _bookViewState extends State<damagedBooksView> {

  final qrkey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;

  late bool error, sending, success;
  late String msg;

  final textController = TextEditingController(); //text controller for textfield

  late ScaffoldMessengerState scaffoldMessenger;

  getBook() async{
    var url = Uri.parse('http://uvalms.ru.com/mobile_app/damageBooks.php');
    var res = await http.get(url, headers: {"Accept":"application/json"});
    try {
      if (res.statusCode == 200) {
        var responsBody = jsonDecode(res.body);
        print(responsBody);
        return responsBody;
      }else{
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }
  }

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      body: SafeArea(
        child: Background(
          child: Container(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left: 25, top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      // left: 25,
                      // top: 35,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Color.fromARGB(255, 243, 243, 243),
                          ),
                          child: Image.asset('assets/svg/back.png', width: 40,),
                        ),
                      )
                    ),
                    Text('Damaged Books', style: GoogleFonts.openSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 7, 7, 7),
                    ),),
                  ],
                ),
                ),
              
                Container(
                  height: 39,
                  margin: EdgeInsets.only(left: 25, right: 25, top: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.orange[50]
                  ),
                  child: Stack(
                    children: <Widget>[
                      TextField(
                        controller: textController,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 111, 111, 111),
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 19, right: 50, bottom: 8),
                          border: InputBorder.none,
                          hintText: 'Search book....',
                          hintStyle: GoogleFonts.openSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 111, 111, 111),
                          ),
                        ),
                      ),
        
                      Positioned(
                          top: 7,
                          right: 55,
                          child: (sending)?Center(
                            child: Container(
                              height:25,
                              width: 25,
                              child: CircularProgressIndicator(
                              backgroundColor: Colors.blue,
                              )
                            )
                          ):Container(
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  sending = true;
                                });
                                _searchBook();
                              },
                              child: Container(
                                child: Image.asset('assets/svg/search.png', width: 30,)
                              ),
                            )
                          ),
                        ),
        
                      Positioned(
                          top: 4,
                          right: 9,
                          child: GestureDetector(
                            onTap: (){
                              showModalBottomSheet(
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)
                                  )
                                ),
        
                                context: context,
                                builder: (context) => buildSheet(),
                                
                              );
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(255, 243, 243, 243),
                              ),
                              child: Image.asset('assets/svg/qr.png', width: 40,),
                            ),
                          )
                        )
                    ],
                  ),
                ),
              
                FutureBuilder(
                  future:getBook(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) { 
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Error fetching data"),
                        );
                      }
        
                      return ListView.builder(
                        padding: EdgeInsets.only(top: 25, right: 25, left: 25),
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length, itemBuilder: (context, index){
                        return GestureDetector(
                          onTap: (() {
                            print('listview tapped');
                          }),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 19),
                            height: 81,
                            width: MediaQuery.of(context).size.width - 50,
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 81,
                                  width: 62,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(image: AssetImage('assets/images/add_book.png')
                                    ),
                                    color: Colors.blueGrey[50],
                                  ),
                                ),
                                SizedBox(width: 21,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${snapshot.data[index]['bookid']}', style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 21, 21, 21),
                                  ),),
                                    SizedBox(height: 5,),
                                    Text('${snapshot.data[index]['bookname']}', style: GoogleFonts.openSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 44, 44, 44),
                                  ),),
                                    SizedBox(height: 5,),
                                    Text('Damaged: ${snapshot.data[index]['damaged_quantity']}',style: GoogleFonts.openSans(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 44, 44, 44),
                                  ),),
                                  ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      );
                   }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _searchBook() async{

    //REST API used with php

    var phpUrl2 = Uri.parse("http://uvalms.ru.com/mobile_app/damageSearch.php");
    var req = await http.post(phpUrl2, body: {"bookid": textController.text}); //sending post request with header data

    if (req.statusCode == 200) {
      print(req.body); //print raw response on console
      var book = jsonDecode(req.body); //decoding json to array

      if (book["error"]) {
        setState(() {
          sending = false;
          error = true;
          msg = book["message"]; //error message from server
          scaffoldMessenger.showSnackBar(SnackBar(content:Text(msg)));
          
        });
      }else{
        textController.text = ""; //after write success, make fields empty
        showModalBottomSheet(
          isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20)
              )
            ),

          context: context,
          builder: (context) => bookData(book),
        );
        setState(() {
          sending = false;
          success = true;//mark success and refresh UI with setState
        });
      }
    }else{
      setState(() {
        error = true;
        msg = "Error during sending data!";
        sending = false;
      });
      scaffoldMessenger.showSnackBar(SnackBar(content:Text(msg)));
    }
  }

   Widget bookData(book) => Container(
    padding: EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Title(color: Colors.black, child: Text('Damaged Book Details')),
        ListBody(
          children: <Widget>[
            Text('ID: ${book["id"]}'),
            Text('Name: ${book["name"]}'),
            Text('Damaged Quantity: ${book["damaged_count"]}'),
          ],
        ),
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );

  Widget buildSheet() => Stack(
    alignment: Alignment.center,
    children: [
      buildQrView(context),
      Positioned(bottom: 80, child: buildControlButton()),
    ],
  );
  
  Widget buildQrView(BuildContext context){
    return QRView(
      key: qrkey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderWidth: 10,
        borderLength: 20,
        borderRadius: 10,
        cutOutSize: MediaQuery.of(context).size.width * 0.8,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      controller.resumeCamera();
    });

    controller.scannedDataStream.listen((barcode){
      setState(() {
        textController.text = barcode.code!;
        controller.pauseCamera();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Success!')),
        );
      });
    });
  }
  
  Widget buildControlButton() => Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Colors.white54,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () async{
            await controller?.toggleFlash();
            setState(() {});
          },
          icon: Icon(Icons.flash_off),
        ),

        IconButton(
          onPressed: () async{
            await controller?.pauseCamera();
            setState(() {});
          },
          icon: Icon(Icons.pause),
        ),

        IconButton(
          onPressed: () async{
            await controller?.resumeCamera();
            setState(() {});
          },
          icon: Icon(Icons.play_arrow),
        ),
      ],
    ),
  );

  void initState() {
      error = false;
      sending = false;
      success = false;
      msg = "";
      super.initState();
  }
}