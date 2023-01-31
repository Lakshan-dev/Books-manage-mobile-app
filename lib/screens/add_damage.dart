import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;


class addDamage extends StatefulWidget {
  const addDamage({Key? key}) : super(key: key);

  @override
  State<addDamage> createState() => _addDamageState();
}

class _addDamageState extends State<addDamage> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  final textController = TextEditingController(); //text controller for textfield

  late ScaffoldMessengerState scaffoldMessenger ;

  late bool error, sending, success;
  late String msg;
  
   
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  void reassemble(){
    super.reassemble();
    if (defaultTargetPlatform == TargetPlatform.android) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  void initState() {
      error = false;
      sending = false;
      success = false;
      msg = "";
      super.initState();
  }

  Future<void> sendData() async{

    //REST API used with php

    var phpUrl = Uri.parse("http://uvalms.ru.com/mobile_app/addDamage.php");
    var res = await http.post(phpUrl, body: {"bookid": textController.text}); //sending post request with header data

    if (res.statusCode == 200) {
      print(res.body); //print raw response on console
      var data = jsonDecode(res.body); //decoding json to array

      if (data["error"]) {
        setState(() {
          sending = false;
          error = true;
          msg = data["message"]; //error message from server
          scaffoldMessenger.showSnackBar(SnackBar(content:Text(msg)));
        });
      }else{
        textController.text = ""; //after write success, make fields empty
        scaffoldMessenger.showSnackBar(SnackBar(content:Text("Book added to damage successfull!")));
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

  @override
  Widget build(BuildContext context) {
    scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Damage'),
        flexibleSpace: Image(
          image: AssetImage('assets/images/topbar.png'),
          fit: BoxFit.cover,
        ),
      ),
      body: Column(
        children: [
          Expanded(flex: 1, child: _buildQrView(context)),
          Container(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(2),
                        child: ElevatedButton(
                          onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                          }, 
                          child: FutureBuilder(
                            future: controller?.getFlashStatus(),
                            builder: (context, snapshot){
                              return Text('On Flash');
                            },
                          )
                        )
                      ),
                      Container(
                        margin: const EdgeInsets.all(2),
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller?.flipCamera();
                            setState(() { });
                          },
                          child: FutureBuilder(
                            future: controller?.getCameraInfo(),
                            builder: (context, snapshot){
                              if(snapshot.data != null){
                                return Text('Change Cam ${describeEnum(snapshot.data!)}');
                              }else{
                                return const Text('loading..');
                              }
                            },
                          )
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(2),
                        child: ElevatedButton(
                          onPressed: () async{
                            await controller?.pauseCamera();
                          },
                          child: const Text('pause',style: TextStyle(fontSize: 20),)
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(2),
                        child: ElevatedButton(
                          onPressed: () async{
                            await controller?.resumeCamera();
                          },
                          child: const Text('resume',style: TextStyle(fontSize: 20))
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              )
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Book ID: ',style: TextStyle(fontSize: 30,),),
                        if(result != null)
                          Text('${result!.code}', style: TextStyle(fontSize: 30, color: Colors.red,),)
                        else
                          const Text('Scanned data display here', style: TextStyle(fontSize: 30,)),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Book ID',
                    ),
                  ),
                ),
                Container(
                  child: ElevatedButton(
                    
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(left: 40, right: 40, top: 15, bottom: 15)),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          side: BorderSide(color: Colors.red)
                        )
                      )
                    ),
                    onPressed: () { 
                      setState(() {
                        sending = true;
                      });
                      sendData();
                    },
                    child: Text(sending?"Sending..":"Add", style: TextStyle(fontSize: 20),)),
                )
              ],
            )
          )
        ],
      )
    );
    
  }


  Widget _buildQrView(BuildContext context){
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      controller.resumeCamera();
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        textController.text = result!.code!;
        controller.pauseCamera();
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  void dispose(){
    controller?.dispose();
    super.dispose();
  }

}