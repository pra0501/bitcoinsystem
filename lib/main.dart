

// ignore_for_file: depend_on_referenced_packages


import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import 'Ui/HomeScreen.dart';
import 'Util/AppLanguage.dart';
import "package:flutter_localizations/flutter_localizations.dart";
import 'Util/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(MyApp(appLanguage: appLanguage));
}

class MyApp extends StatelessWidget {
  final AppLanguage? appLanguage;
  const MyApp({super.key, this.appLanguage});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
        create: (_) => appLanguage!,
        child: Consumer<AppLanguage>(
            builder: (context, model, child) {
              return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  locale: model.appLocal,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],

                  supportedLocales: const [
                    Locale('en', 'UK'),
                    Locale('ar', ''),
                    Locale('de', ''),
                    Locale('es', ''),
                    Locale('fi', ''),
                    Locale('fr', ''),
                    Locale('it', ''),
                    Locale('nl', ''),
                    Locale('nb', ''),
                    Locale('pt', ''),
                    Locale('ru', ''),
                    Locale('sv', '')
                  ],
                  home:  ShowCaseWidget(
                    builder: Builder(builder: (context) => const MyHomePage()),
                  ),
              );
            })
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 3000)).then((_) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(children: [
            Image.asset('assets/images/splash_screen_image.png', width: MediaQuery.of(context).size.width, fit: BoxFit.fitWidth),
            Container(
                alignment: Alignment.center,
                child: Image.asset('assets/images/bitcoin_pro_app_icon.png', width: 120, height: 120,))
          ]),
        )
    );
  }
}

