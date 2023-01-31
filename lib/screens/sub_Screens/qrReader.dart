// import 'dart:html';

import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:uvatest/components/background.dart';
import 'package:uvatest/components/custom_tab_indicator.dart';
import 'package:uvatest/single_classes/book.dart';

import 'package:http/http.dart' as http;


class qrReader extends StatefulWidget {
  const qrReader({Key? key}) : super(key: key);

  @override
  State<qrReader> createState() => _qrReaderState();
}

class _qrReaderState extends State<qrReader> {

  final qrkey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;

  final textController = TextEditingController(); //text controller for textfield

  @override
  void dispose(){
    controller?.dispose();
    super.dispose();
  }

  // void reassemble(){
  //   super.reassemble();
  //   if (defaultTargetPlatform == TargetPlatform.android) {
  //     controller!.pauseCamera();
  //   }
  //   controller!.resumeCamera();
  // }

  @override
  Widget build(BuildContext context) {
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
                    Positioned(
                      left: 25,
                      top: 35,
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
                    Text('Listed Books', style: GoogleFonts.openSans(
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
                        right: 50,
                        child: GestureDetector(
                          onTap: (){
                            print('tap');
                          },
                          child: Image.asset('assets/svg/search.png', width: 30,))
                      ),
                      Positioned(
                        top: 4,
                        right: 6,
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
                            child: Image.asset('assets/svg/qr.png', width: 35,),
                          ),
                        )
                      )
                    ],
                  ),
                ),
              
                Container(
                  
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget buildSheet() => Stack(
    // padding: EdgeInsets.all(16),
    alignment: Alignment.center,
      // mainAxisSize: MainAxisSize.min,
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
}
