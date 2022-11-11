// ignore_for_file: deprecated_member_use, import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'privacy_policy.dart';
import 'dashboard_helper.dart';
import 'coin_page.dart';
import 'trends_page.dart';
import 'gainloose.dart';
import 'localization/AppLanguage.dart';
import 'localization/app_localizations.dart';
import 'models/LanguageData.dart';
import 'models/Bitcoin.dart';
import 'models/PortfolioBitcoin.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key}) : super(key: key);

  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  List<Bitcoin> bitcoinList = [];
  SharedPreferences? sharedPreferences;
  num _size = 0;
  double totalValuesOfPortfolio = 0.0;
  final _formKey = GlobalKey<FormState>();
  String? URL;
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();

  final PageStorageBucket bucket = PageStorageBucket();
  String? languageCodeSaved;

  TextEditingController? coinCountTextEditingController;
  TextEditingController? coinCountEditTextEditingController;
  final dbHelper = DatabaseHelper.instance;
  List<PortfolioBitcoin> items = [];

  @override
  void initState() {
    // fetchRemoteValue();
    callBitcoinApi();
    coinCountTextEditingController = new TextEditingController();
    coinCountEditTextEditingController = new TextEditingController();
    dbHelper.queryAllRows().then((notes) {
      notes.forEach((note) {
        items.add(PortfolioBitcoin.fromMap(note));
        totalValuesOfPortfolio = totalValuesOfPortfolio + note["total_value"];
      });
      setState(() {});
    });
    super.initState();
    getSharedPrefData();
    super.initState();
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

  @override
  void dispose() {
    super.dispose();
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
      URL = remoteConfig.getString('bit_evo_url').trim();

      print(URL);
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
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
                height: 300,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xff0f2f2f3),
                  image: DecorationImage(
                    image: AssetImage("assets/image/Container.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(AppLocalizations.of(context).translate('portfolio'),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 200,
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
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
                              );
                            }, // Image tapped
                            child: Image.asset(
                              'assets/image/privacy-policy.png',
                              fit: BoxFit.cover, // Fixes border issues
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '\$${totalValuesOfPortfolio.toStringAsFixed(2)}',textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontSize: 35,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const DashboardNew()),
                                  );
                                }, // Image tapped
                                child: Image.asset(
                                  'assets/image/Group 7.png',
                                  fit: BoxFit.cover, // Fixes border issues
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Top Coins",
                                style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const TrendPage()),
                                  );
                                }, // Image tapped
                                child: Image.asset(
                                  'assets/image/Group 8.png',
                                  fit: BoxFit.cover, // Fixes border issues
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Trends",
                                style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const CoinsPage()),
                                  );
                                }, // Image tapped
                                child: Image.asset(
                                  'assets/image/Group 9.png',
                                  fit: BoxFit.cover, // Fixes border issues
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Coins",
                                style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()),
                                  );
                                }, // Image tapped
                                child: Image.asset(
                                  'assets/image/Group 10.png',
                                  fit: BoxFit.cover, // Fixes border issues
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Home",
                                style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                )
            ),
            Expanded(
                child: items.length > 0 && bitcoinList.length > 0
                    ? ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int i) {
                      return Card(
                        elevation: 1,
                        child: Container(
                          height: MediaQuery.of(context).size.height/11,
                          width: MediaQuery.of(context).size.width/.5,
                          child:GestureDetector(
                              onTap: () {
                                showPortfolioEditDialog(items[i]);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        height: 70,
                                        width:60,
                                        child: FadeInImage(
                                          placeholder: const AssetImage('assets/image/cob.png'),
                                          // image: NetworkImage("$URL/Bitcoin/resources/icons/${items[i].name.toLowerCase()}.png"),
                                          image: NetworkImage("http://45.34.15.25:8080/Bitcoin/resources/icons/${items[i].name.toLowerCase()}.png"),
                                        ),
                                      )
                                  ),
                                  // SizedBox(width:5),
                                  Padding(
                                      padding: const EdgeInsets.all(5),
                                      child:Container(
                                          width:90,
                                          child:Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text('${items[i].name}',
                                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.left,
                                              ),
                                              Container(
                                                child: Text('\$ ${items[i].rateDuringAdding.toStringAsFixed(2)}',
                                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
                                              ),
                                            ],
                                          )
                                      )
                                  ),
                                  // SizedBox(width:20),
                                  Padding(
                                      padding: const EdgeInsets.all(5),
                                      child:Container(
                                          width:30,
                                          child:Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(' ${items[i].numberOfCoins.toStringAsFixed(0)}',
                                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                  textAlign: TextAlign.end,),
                                              ]
                                          ))
                                  ),
                                  const SizedBox(width:20),
                                  Container(
                                      width:110,
                                      child:Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            child: Text('\$${items[i].totalValue.toStringAsFixed(2)}',
                                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.end,),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _showdeleteCoinFromPortfolioDialog(items[i]);
                                            },
                                            child:Image.asset("assets/image/trash 1.png")
                                          ),
                                        ],
                                      )),
                                  const SizedBox(
                                    width: 2,
                                  )
                                ],
                              )
                          ),
                        ),
                      );
                    })
                    : const Center(
                    child: Text("No Coins Added"))
            ),
          ],
        ),
      ),
    );
  }


  Future<void> callBitcoinApi() async {
    // var uri = '$URL/Bitcoin/resources/getBitcoinList?size=${_size}';
    var uri = 'http://45.34.15.25:8080/Bitcoin/resources/getBitcoinList?size=${_size}';

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

  Future<void> showPortfolioEditDialog(PortfolioBitcoin bitcoin) async {
    coinCountEditTextEditingController!.text = bitcoin.numberOfCoins.toInt().toString();
    showCupertinoModalPopup(
        context: context,
        builder: (ctxt) => Container(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.white,
              // title: Text(AppLocalizations.of(context).translate('update_coins'),
              //     style: const TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(top:50),
                //   child: Text(AppLocalizations.of(context).translate('enter_coins'),
                //       style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold)),
                // ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: coinCountEditTextEditingController,
                      style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ], // O
                      //only numbers can be entered
                      validator: (val) {
                        if (coinCountEditTextEditingController!.value.text == "" ||
                            int.parse(coinCountEditTextEditingController!.value.text) <= 0) {
                          return "at least 1 coin should be added";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                        elevation: 1,
                        child:Padding(
                            padding: const EdgeInsets.only(top:10,bottom:10,left:30,right: 50),
                            child:Row(
                              children: [
                                Container(
                                    height: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: FadeInImage(
                                        placeholder: const AssetImage('assets/image/cob.png'),
                                        image: NetworkImage(
                                          // "$URL/Bitcoin/resources/icons/${bitcoin.name.toLowerCase()}.png"),
                                            "http://45.34.15.25:8080/Bitcoin/resources/icons/${bitcoin.name.toLowerCase()}.png"),
                                      ),
                                    )
                                ),
                                const SizedBox(
                                    width:10,
                                ),
                                Text(bitcoin.name,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
                              ],
                            )
                        )
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      child:TextButton(
                        style: ButtonStyle(
                          // foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent,),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35.0),
                                  // side: BorderSide(color: Color(0xfff4f727))
                                )
                            )
                        ),
                        // height: 60,
                        // shape: CircleBorder(
                        //     side: BorderSide.none
                        // ),
                        child: const Icon(Icons.arrow_forward, color: Colors.white, size: 35,),
                        // color: Colors.blueAccent,
                        onPressed: () =>
                            _updateSaveCoinsToLocalStorage(bitcoin),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
    );
  }

  getCurrentRateDiff(PortfolioBitcoin items, List<Bitcoin> bitcoinList) {
    Bitcoin j = bitcoinList.firstWhere((element) => element.name == items.name);

    double newRateDiff = j.rate! - items.rateDuringAdding;
    return newRateDiff;
  }

  _updateSaveCoinsToLocalStorage(PortfolioBitcoin bitcoin) async {
    if (_formKey.currentState!.validate()) {
      int adf = int.parse(coinCountEditTextEditingController!.text);
      print(adf);
      Map<String, dynamic> row = {
        DatabaseHelper.columnName: bitcoin.name,
        DatabaseHelper.columnRateDuringAdding: bitcoin.rateDuringAdding,
        DatabaseHelper.columnCoinsQuantity:
        double.parse(coinCountEditTextEditingController!.value.text),
        DatabaseHelper.columnTotalValue: (adf) * (bitcoin.rateDuringAdding),
      };
      final id = await dbHelper.update(row);
      print('inserted row id: $id');
      sharedPreferences = await SharedPreferences.getInstance();
      setState(() {
        sharedPreferences!.setString("currencyName", bitcoin.name);
        sharedPreferences!.setInt("index", 3);
        //sharedPreferences!.setString("title", AppLocalizations.of(context).translate('portfolio'));
        sharedPreferences!.commit();
      });
      Navigator.pushNamedAndRemoveUntil(context, '/homePage', (r) => false);
    } else {}
  }

  void _showdeleteCoinFromPortfolioDialog(PortfolioBitcoin item) {
    showCupertinoModalPopup(
        context: context,
        builder: (ctxt) => Container(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.white,
              // title: Text(AppLocalizations.of(context).translate('remove_coins'),
              //     style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            body: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(top:50),
                //   child: Text(AppLocalizations.of(context).translate('do_you'),
                //     style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                // ),
                const SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                        elevation: 1,
                        child:Padding(
                            padding: const EdgeInsets.only(top:10,bottom:10,left:30,right: 50),
                            child:Row(
                              children: [
                                Container(
                                    height: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: FadeInImage(
                                        placeholder: const AssetImage('assets/image/cob.png'),
                                        image: NetworkImage(
                                          // "$URL/Bitcoin/resources/icons/${item.name.toLowerCase()}.png"),
                                            "http://45.34.15.25:8080/Bitcoin/resources/icons/${item.name.toLowerCase()}.png"),
                                      ),
                                    )
                                ),
                                const SizedBox(
                                    width:10
                                ),
                                Text(item.name,style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)
                              ],))

                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: TextButton(
                        style: ButtonStyle(
                          // foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent,),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35.0),
                                  // side: BorderSide(color: Color(0xfff4f727))
                                )
                            )
                        ),
                        // height: 60,
                        // shape: CircleBorder(
                        //     side: BorderSide.none
                        // ),
                        child: const Icon(Icons.arrow_forward, color: Colors.white, size: 35,),
                        // color: Colors.redAccent,
                        onPressed: () => _deleteCoinsToLocalStorage(item),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )
    );
  }

  _deleteCoinsToLocalStorage(PortfolioBitcoin item) async {
    // int adf = int.parse(coinCountEditTextEditingController.text);
    // print(adf);

    final id = await dbHelper.delete(item.name);
    print('inserted row id: $id');
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences!.setInt("index", 2);
      // sharedPreferences!.setString("title", AppLocalizations.of(context).translate('coins'));
      sharedPreferences!.commit();
    });
    Navigator.pushNamedAndRemoveUntil(context, '/homePage', (r) => false);
  }



}
