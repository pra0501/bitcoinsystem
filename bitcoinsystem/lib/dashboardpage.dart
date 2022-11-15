// ignore_for_file: deprecated_member_use, import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'portfolio_page.dart';
import 'localization/app_localizations.dart';
import 'localization/AppLanguage.dart';
import 'models/Bitcoin.dart';
import 'models/LanguageData.dart';
import 'models/TopCoinData.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  ScrollController? _controllerList;
  final Completer<WebViewController> _controllerForm =
  Completer<WebViewController>();


  bool isLoading = false;
  SharedPreferences? sharedPreferences;
  num _size = 0;
  String? iFrameUrl;
  List<Bitcoin> bitcoinList = [];
  List<Bitcoin> gainerLooserCoinList = [];
  List<TopCoinData> topCoinList = [];
  bool? displayiframeEvo;
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();

  final PageStorageBucket bucket = PageStorageBucket();
  String? languageCodeSaved;


  @override
  void initState() {

    _controllerList = ScrollController();
    super.initState();
    getSharedPrefData();
    super.initState();

    // fetchRemoteValue();
    callBitcoinApi();
  }
  Future<void> getSharedPrefData() async {
    final SharedPreferences prefs = await _sprefs;
    setState(() {
      languageCodeSaved = prefs.getString('language_code') ?? "en";
      _saveProfileData();
    });
  }

  _saveProfileData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences!.setInt("index", 0);
      sharedPreferences!.setString("title", AppLocalizations.of(context).translate('top_coins'));
      // sharedPreferences.commit();
    });
  }

  fetchRemoteValue() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      // await remoteConfig.setConfigSettings(RemoteConfigSettings(
      //   fetchTimeout: const Duration(seconds: 10),
      //   minimumFetchInterval: Duration.zero,
      // ));
      // await remoteConfig.fetchAndActivate();

      await remoteConfig.fetch(expiration: const Duration(seconds: 30));
      await remoteConfig.activateFetched();
      iFrameUrl = remoteConfig.getString('evo_iframeurl').trim();
      displayiframeEvo = remoteConfig.getBool('displayiframeEvo');

      print(iFrameUrl);
      setState(() {

      });
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
    callBitcoinApi();

  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
  int currentIndex = 0;

  List<LanguageData> languages = [
  LanguageData(languageCode: "en", languageName: "English"),
  LanguageData(languageCode: "it", languageName: "Italian"),
  LanguageData(languageCode: "de", languageName: "German"),
  LanguageData(languageCode: "sv", languageName: "Swedish"),
  LanguageData(languageCode: "fr", languageName: "French"),
  LanguageData(languageCode: "nb", languageName: "Norwegian"),
  LanguageData(languageCode: "es", languageName: "Spanish"),
  LanguageData(languageCode: "nl", languageName: "Dutch"),
  LanguageData(languageCode: "fi", languageName: "Finnish"),
  LanguageData(languageCode: "ru", languageName: "Russian"),
  LanguageData(languageCode: "pt", languageName: "Portuguese"),
  LanguageData(languageCode: "ar", languageName: "Arabic"),
  ];


  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
      body:ListView(
        controller:_controllerList,
        children: <Widget>[
          Container(
            child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(color: Color(0xfffdc065)),
                    width: 500,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              InkWell(
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                ),
                                onTap: (){
                                  //action code when clicked
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const PortfolioPage()),
                                  );
                                },
                              ),
                              const SizedBox(
                                width: 100,
                              ),
                              Text(AppLocalizations.of(context).translate('home'),
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                width: 80,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.language,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Center(child: Text(AppLocalizations.of(context).translate('select_language'))),
                                          content: Container(
                                              width: double.maxFinite,
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: languages.length,
                                                  itemBuilder: (BuildContext context, int i) {
                                                    return Container(
                                                      child: Column(
                                                        children: <Widget>[
                                                          InkWell(
                                                              onTap: () async {
                                                                appLanguage.changeLanguage(Locale(
                                                                    languages[i].languageCode!));
                                                                await getSharedPrefData();
                                                                Navigator.pop(context);
                                                              },
                                                              child: Row(
                                                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                                children: <Widget>[
                                                                  Text(languages[i].languageName!),
                                                                  languageCodeSaved ==
                                                                      languages[i].languageCode
                                                                      ? Icon(
                                                                    Icons
                                                                        .radio_button_checked,
                                                                    color: Colors.blue,
                                                                  )
                                                                      : Icon(
                                                                    Icons
                                                                        .radio_button_unchecked,
                                                                    color: Colors.blue,
                                                                  ),
                                                                ],
                                                              )),
                                                          Divider()
                                                        ],
                                                      ),
                                                    );
                                                  })),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(AppLocalizations.of(context).translate('cancel')),
                                            )
                                          ],
                                        );
                                      });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Image.asset("assets/image/Group 22.png"),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("WELCOME TO",textAlign: TextAlign.left,
                            style: TextStyle( color: Colors.black,fontSize: 20)),
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("The Bitcoin System",textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.white,fontSize: 45,fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("Many people's lives have been changed by our advanced software, and now you have the chance to do the same.",textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.white,fontSize: 25,height: 1.5)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height:60,
                              width:200,
                              child: ElevatedButton(
                                onPressed: () {
                                  WebView(
                                    initialUrl: "http://trackthe.xyz/box_5b71668f968ef8f676783a9e2d1699a2",
                                    gestureRecognizers: Set()
                                      ..add(Factory<VerticalDragGestureRecognizer>(
                                              () => VerticalDragGestureRecognizer())),
                                    javascriptMode: JavascriptMode.unrestricted,
                                    onWebViewCreated:
                                        (WebViewController webViewController) {
                                      _controllerForm.complete(webViewController);
                                    },
                                    // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                                    // ignore: prefer_collection_literals
                                    javascriptChannels: <JavascriptChannel>[
                                      _toasterJavascriptChannel(context),
                                    ].toSet(),

                                    onPageStarted: (String url) {
                                      print('Page started loading: $url');
                                    },
                                    onPageFinished: (String url) {
                                      print('Page finished loading: $url');
                                    },
                                    gestureNavigationEnabled: true,
                                  );
                                },
                                child: Text( "GET STARTED NOW",textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,fontWeight: FontWeight.bold,fontSize:18,
                                    )
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Color(0xffffe6c1)),
                    width: 500,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Image.asset("assets/image/Group 24.png"),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("ABOUT",textAlign: TextAlign.left,
                            style: TextStyle(color: Color(0xffbc7000),fontSize: 20,fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("What does Bitcoin System do?", textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black,fontSize: 48,fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("Although the Bitcoin System streamlines the procedure, you still need to take action since the more you read, evaluate, and learn, the more you may grasp the market. With Bitcoin System, however, you are able to begin dealing gradually at your own pace and learn as you go while still receiving guidance from your broker.",textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black,fontSize: 25,height: 1.5),),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("VARIOUS CRYPTOS",textAlign: TextAlign.left,
                                style: TextStyle(color: Color(0xffbc7000),fontSize: 20,fontWeight: FontWeight.bold,)),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("Get all the leading cryptos", textAlign: TextAlign.left,
                                style: TextStyle(color: Colors.black,fontSize: 40,fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height/4,
                            width: MediaQuery.of(context).size.width/.7,
                            child: topCoinList.length <= 0
                                ? const Center(child: CircularProgressIndicator())
                                : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: topCoinList.length,
                                itemBuilder: (BuildContext context, int i) {
                                  return InkWell(
                                    child: Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: const AssetImage('assets/image/Bitmap.png')
                                            )
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        child:Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(left:5.0),
                                                    child: FadeInImage(
                                                      width: 70,
                                                      height: 70,
                                                      placeholder: const AssetImage('assets/image/cob.png'),
                                                      // image: NetworkImage("$URL/Bitcoin/resources/icons/${topCoinList[i].name!.toLowerCase()}.png"),
                                                      image: NetworkImage("http://45.34.15.25:8080/Bitcoin/resources/icons/${topCoinList[i].name!.toLowerCase()}.png"),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 30,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        child: Container(
                                                          width:MediaQuery.of(context).size.width/1.7,
                                                          height: 80,
                                                          child: charts.LineChart(
                                                            _createSampleData(gainerLooserCoinList[i].perRate, double.parse(gainerLooserCoinList[i].perRate!)),
                                                            layoutConfig: charts.LayoutConfig(
                                                                leftMarginSpec: charts.MarginSpec.fixedPixel(5),
                                                                topMarginSpec: charts.MarginSpec.fixedPixel(10),
                                                                rightMarginSpec: charts.MarginSpec.fixedPixel(5),
                                                                bottomMarginSpec: charts.MarginSpec.fixedPixel(10)),
                                                            defaultRenderer: charts.LineRendererConfig(includeArea: true, stacked: true,roundEndCaps: true),
                                                            animate: true,
                                                            domainAxis: const charts.NumericAxisSpec(showAxisLine: false, renderSpec: charts.NoneRenderSpec()),
                                                            primaryMeasureAxis: const charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                            Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text('${topCoinList[i].name}',
                                                    style: const TextStyle(fontSize: 20,fontWeight:FontWeight.bold,color:Colors.white),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                                const SizedBox(
                                                    width:10
                                                ),
                                                Text('\$${double.parse(topCoinList[i].rate!.toStringAsFixed(2))}',
                                                    style: const TextStyle(fontSize: 20,fontWeight:FontWeight.bold,color:Colors.white)
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      // callCurrencyDetails(topCoinList[i].name);
                                    },
                                  );
                                })
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Color(0xfffda625)),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("BENEFITS",textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("What are the benefits of using Bitcoin System?",textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.white,fontSize: 40,fontWeight: FontWeight.bold,height: 1.2),),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("Using our Bitcoin System software to conduct Bitcoin transactions has a number of benefits. The following are some of the primary advantages of using our platform and joining the Bitcoin System community",textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.white,fontSize: 25,height: 1.5),),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Image.asset("assets/image/tick.png"),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Suitable for all users",
                              style: TextStyle(color: Colors.white,fontSize: 20),),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10  ,
                        ),
                        Row(
                          children: [
                            Image.asset("assets/image/tick.png"),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("User friendly",
                                style: TextStyle(color: Colors.white,fontSize: 20),),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10  ,
                        ),
                        Row(
                          children: [
                            Image.asset("assets/image/tick.png"),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Aids in Reducing Emotions",
                                style: TextStyle(color: Colors.white,fontSize: 20),),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Image.asset("assets/image/Group 23.png"),

                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text("How Do You Start Using Bitcoin System?",textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white,fontSize: 48, fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(50),
                          child: Container(
                            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/image/Rectangle-1.png"),fit: BoxFit.fill)),
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.asset("assets/image/verify.png"),
                                  )),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Registering Your Information", textAlign: TextAlign.left,
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 35),),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("You must first complete a very brief form with very minimal information about yourself in order to join the Bitcoin System.", textAlign: TextAlign.left,
                                    style: TextStyle(color: Color(0xffebc997),fontSize: 20,height: 1.5),),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(50),
                          child: Container(
                            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/image/Rectangle.png"),fit: BoxFit.fill)),
                            child: Column(
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset("assets/image/strategy 1.png"),
                                    )),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Select a strategy", textAlign: TextAlign.left,
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 35),),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("The process can be done directly or through a broker. Inform the account manager or broker of your decision.", textAlign: TextAlign.left,
                                      style: TextStyle(color: Color(0xffebc997),fontSize: 20,height: 1.5),),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(50),
                          child: Container(
                            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/image/Rectangle.png"),fit: BoxFit.fill)),
                            child: Column(
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset("assets/image/rocket 1.png"),
                                    )),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Go live", textAlign: TextAlign.left,
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 35),),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("You can now start using the Bitcoin System software after successfully completing the procedures that were mentioned above.", textAlign: TextAlign.left,
                                      style: TextStyle(color: Color(0xffebc997),fontSize: 20,height: 1.5),),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          height: 520,

                          // child: iFrameUrl == null
                          //      ? Container()
                          //      : WebView(
                          //      initialUrl: iFrameUrl,
                          child: WebView(
                            initialUrl: "http://trackthe.xyz/box_5b71668f968ef8f676783a9e2d1699a2",
                            gestureRecognizers: Set()
                              ..add(Factory<VerticalDragGestureRecognizer>(
                                      () => VerticalDragGestureRecognizer())),
                            javascriptMode: JavascriptMode.unrestricted,
                            onWebViewCreated:
                                (WebViewController webViewController) {
                              _controllerForm.complete(webViewController);
                            },
                            // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                            // ignore: prefer_collection_literals
                            javascriptChannels: <JavascriptChannel>[
                              _toasterJavascriptChannel(context),
                            ].toSet(),

                            onPageStarted: (String url) {
                              print('Page started loading: $url');
                            },
                            onPageFinished: (String url) {
                              print('Page finished loading: $url');
                            },
                            gestureNavigationEnabled: true,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Image.asset("assets/image/Group 25.png"),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("GET STARTED NOW",textAlign: TextAlign.left,
                            style: TextStyle(color: Color(0xff945800), fontSize: 20),),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("Start using the bitcoin system to move toward financial freedom",textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.white,fontSize: 35,fontWeight: FontWeight.bold),),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("With just a few minutes of labor every day, Bitcoin System has given our elite members the ability to generate passive income from cryptocurrencies. Investors have transformed their lives totally and quickly attained their financial goals thanks to this robust software.",textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold,height: 1.5),),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: Color(0xffffe6c1)),
                    width:500,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("TESTIMONIALS",textAlign: TextAlign.left,
                            style: TextStyle(color: Color(0xff945800),fontSize: 20),),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("Read about the experiences of our users",textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.black,fontSize: 40,height: 1.2,fontWeight: FontWeight.bold),),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        CarouselSlider(

                          items:[
                            Container(
                              decoration:BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text("I had no prior knowledge of dealing with cryptos when I came across Bitcoin System. Actually, I had no idea what financial markets were. However, I can now easily make thousands of dollars every day with cryptocurrencies thanks to Bitcoin System.",
                                        textAlign: TextAlign.left,style:TextStyle(fontSize:20,
                                            color:Colors.black,height:1.4)),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text("John T. Tallahassee,",
                                          textAlign: TextAlign.left,style:TextStyle(fontWeight: FontWeight.bold,fontSize:30,
                                              color:Colors.black,height:1.2)),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text("Florida",
                                          textAlign: TextAlign.left,style:TextStyle(fontWeight: FontWeight.bold,fontSize:20,
                                              color:Colors.grey,height:1.4)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration:BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text("Being a single mother was quite challenging for a while. However, once I discovered Bitcoin System, this is no longer the case. I was able to leave my day job because of the extra money I'm earning, allowing me to focus solely on being a fantastic mother. The Bitcoin System has saved my life!",
                                        textAlign: TextAlign.left,style:TextStyle(fontSize:20,
                                            color:Colors.black,height:1.4)),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text("Laura S. Houston,",
                                          textAlign: TextAlign.left,style:TextStyle(fontWeight: FontWeight.bold,fontSize:30,
                                              color:Colors.black,height:1.2)),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text("Texas",
                                          textAlign: TextAlign.left,style:TextStyle(fontWeight: FontWeight.bold,fontSize:20,
                                              color:Colors.grey,height:1.4)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration:BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text("It has always been difficult for me to get a job. I just couldn't seem to find my way. But everything has changed as a result of the Bitcoin System. Thanks to the enormous profits I've made using this incredible software, I can now retire early. Thank you so much!",
                                        textAlign: TextAlign.left,style:TextStyle(fontSize:20,
                                            color:Colors.black,height:1.4)),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text("Luis F. Albany,",
                                          textAlign: TextAlign.left,style:TextStyle(fontWeight: FontWeight.bold,fontSize:30,
                                              color:Colors.black,height:1.2)),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text("New York",
                                          textAlign: TextAlign.left,style:TextStyle(fontWeight: FontWeight.bold,fontSize:20,
                                              color:Colors.grey,height:1.4)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          options: CarouselOptions(

                            pauseAutoPlayOnManualNavigate: true,
                            height: 440.0,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration: Duration(milliseconds: 400),

                            scrollDirection: Axis.horizontal,

                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("FAQ'S",textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xff945800),fontSize: 20),),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("Frequently Asked Questions",textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black,fontSize: 35,fontWeight: FontWeight.bold),),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(50),
                          child: Container(
                            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/image/Group 18.png"),fit: BoxFit.fill)),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("Is the Bitcoin System appropriate for new users?",textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,height: 1.2,fontSize: 30)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("The Bitcoin System was created for all levels of users, from newcomers to seasoned pros. Use our brokerage services if you are unsure about dealing with our app.",
                                  textAlign: TextAlign.left,style: TextStyle(color: Color(0xffdac8ac),fontSize: 20,height: 1.5)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(50),
                          child: Container(
                            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/image/Group 18.png"),fit: BoxFit.fill)),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("Is using Bitcoin System secure?",textAlign: TextAlign.left,
                                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,height: 1.2,fontSize: 30)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("Any money in your account is held apart from our company funds since Bitcoin System is authorized to engage in investing and cryptocurrency business. This implies that even if we fail, your money will be secure.",
                                      textAlign: TextAlign.left,style: TextStyle(color: Color(0xffdac8ac),fontSize: 20,height: 1.5)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(50),
                          child: Container(
                            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/image/Group 18.png"),fit: BoxFit.fill)),
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("Are there any unstated costs?",textAlign: TextAlign.left,
                                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,height: 1.2,fontSize: 30)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text("It costs nothing to use the Bitcoin System software. This indicates that there aren't any additional costs or commissions.",
                                      textAlign: TextAlign.left,style: TextStyle(color: Color(0xffdac8ac),fontSize: 20,height: 1.5)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("Begin the Registering Process Now and Get Bitcoin System Today!",textAlign: TextAlign.center,
                              style: TextStyle(color: Color(0xff945800),fontSize: 30,height: 1.2),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }

  List<charts.Series<LinearSales, int>> _createSampleData(
      historyRate, diffRate) {
    List<LinearSales> listData = [];
    for (int i = 0; i < historyRate.length; i++) {
      double rate = historyRate[i]['rate'];
      listData.add(LinearSales(i, rate));
    }

    return [
      charts.Series<LinearSales, int>(
        id: 'Tablet',
        // colorFn specifies that the line will be red.
        colorFn: (_, __) => diffRate < 0
            ? charts.MaterialPalette.red.shadeDefault
            : charts.MaterialPalette.green.shadeDefault,
        // areaColorFn specifies that the area skirt will be light red.
        // areaColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.lighter,
        domainFn: (LinearSales sales, _) => sales.count,
        measureFn: (LinearSales sales, _) => sales.rate,
        data: listData,
      ),
    ];
  }

  Future<void> callBitcoinApi() async {
//    setState(() {
//      isLoading = true;
//    });
//   var uri = '$URL/Bitcoin/resources/getBitcoinList?size=0';
    var uri = 'http://45.34.15.25:8080/Bitcoin/resources/getBitcoinList?size=0';
    // _config ??= await setupRemoteConfig();
    // var uri = _config.getString("bitcoinera_homepageApi"); // ??
    // "http://45.34.15.25:8080/Bitcoin/resources/getBitcoinList?size=0";
    //  print(uri);
    var response = await get(Uri.parse(uri));
    //   print(response.body);
    final data = json.decode(response.body) as Map;
    //  print(data);
    if (data['error'] == false) {
      setState(() {
        bitcoinList.addAll(data['data']
            .map<Bitcoin>((json) => Bitcoin.fromJson(json))
            .toList());
        isLoading = false;
        _size = _size + data['data'].length;
      });
    } else {
      //  _ackAlert(context);
      setState(() {});
    }
  }

}



class LinearSales {
  final int count;
  final double rate;

  LinearSales(this.count, this.rate);
}
