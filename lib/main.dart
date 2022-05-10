
import 'package:assets_audio_player/generated/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'screens/Splashscreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future main() async {

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: appName,
    localizationsDelegates:
    [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('fr', 'FR'),
    ],
    theme: new ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: "CeraPro",
      pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      }),
    ),
    home: new SplashScreen(),
  ));

}
