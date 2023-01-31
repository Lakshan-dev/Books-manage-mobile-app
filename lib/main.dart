import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uvatest/constants.dart';
import 'package:uvatest/screens/bookView.dart';
import 'package:uvatest/screens/damageBookView.dart';
import 'package:uvatest/screens/login/login.dart';
import 'package:uvatest/screens/sub_Screens/qrReader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/add_damage.dart';
import 'screens/home_page.dart';

void main() {
  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MyApp(), // Wrap your app
  ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // English, no country code
        Locale('sn', ''), 
      ],

      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'UVALMS',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: kPrimaryLightColor,
          iconColor: kPrimaryColor,
          prefixIconColor: kPrimaryColor,
          contentPadding: EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide.none,
          ),
        )
      ),
      home: LoginScreen(),
      initialRoute: '/',
      routes: {
        // '/home':(context) => Homepage(),
        '/addDamage':(context) => addDamage(),
        '/login':(context) => LoginScreen(),
        // '/allBooks':(context) => allbooks(),
        '/allBooks':(context) => bookView(),
        // '/damageBooks':(context) => damageBooks(),
        '/damageBooks':(context) => damagedBooksView(),
        '/qr':(context) => qrReader(),
      },
    );
  }
}

