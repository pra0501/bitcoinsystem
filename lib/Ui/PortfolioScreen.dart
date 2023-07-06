
// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:bitcoinproapp/Ui/CoinsScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import '../Models/Bitcoin.dart';
import '../Models/PortfolioBitcoin.dart';
import '../Util/app_localizations.dart';
import '../Util/color_util.dart';
import '../Util/dashboard_helper.dart';
import '../Util/font_util.dart';
import '../Util/text_widgets.dart';

class PortfolioScreen extends StatefulWidget {
  String ?ApiUrl;
  PortfolioScreen(this.ApiUrl, {super.key});
  @override
  PortfolioScreenState createState() => PortfolioScreenState();

}

class PortfolioScreenState extends State<PortfolioScreen> {

  double totalValuesOfPortfolio = 0.0;
  double totalValuesOfPortfolio02 = 0.0;
  double totalValuesOfPortfolio03 = 0.0;
  double totalValuesOfPortfolio04 = 0.0;
  final dbHelper = DatabaseHelper.instance;
  List<PortfolioBitcoin> items = [];

  SharedPreferences? sharedPreferences;
  TextEditingController? coinCountEditTextEditingController;
  final _formKey = GlobalKey<FormState>();

  List<Bitcoin> bitcoinList = [];

  bool onLongPressed = false;
  final _key0 = GlobalKey();
  BuildContext? myContext;

  @override
  void initState() {
    dbHelper.queryAllRows().then((notes) {
      notes.forEach((note) {
        items.add(PortfolioBitcoin.fromMap(note));
        totalValuesOfPortfolio = totalValuesOfPortfolio + note["total_value"];
      });
      setState(() {});
    });
    coinCountEditTextEditingController = new TextEditingController();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ShowCaseWidget.of(myContext!)!.startShowCase([_key0]);
    });
    getCoinsList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
        builder: Builder(
            builder: (context) {
              myContext = context;
              return Scaffold(
      backgroundColor: getDarkBackground(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Image.asset("assets/images/back_arrow_icon.png",height: 18,width: 18, color: getColorFromHex('#2B2D33')),
                    ),
                  ),

                  Container(
                    alignment: Alignment.center,
                    child: getTextWidgetMaxLines(
                        AppLocalizations.of(context)!.translate('portfolio')!,
                        16,
                        getColorFromHex('#2B2D33'),
                        FontWeight.w700,
                        TextAlign.center,
                        FontUtil.ROBOTOBOLD, 1),
                  ),

                  const SizedBox(
                    width: 18,
                    height: 18,
                  )
                ],
              ),
            ),

            Container(
              height: 143,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: getColorFromHex('#586CD0')),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: getTextWidgetMaxLines(
                        AppLocalizations.of(context)!.translate('total_portfolio')!,
                        12,
                        getColorFromHex('#FFFFFF'),
                        FontWeight.w500,
                        TextAlign.center,
                        FontUtil.ROBOTOMEDIUM, 1),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    alignment: Alignment.topLeft,
                    child: getTextWidgetMaxLines(
                        '\$ ${totalValuesOfPortfolio.toStringAsFixed(2)}',
                        30,
                        getColorFromHex('#FFFFFF'),
                        FontWeight.w500,
                        TextAlign.center,
                        FontUtil.ROBOTOMEDIUM, 1),
                  ),
                ],


              ),
            ),

            const SizedBox(height: 36),

            // Container(
            //   decoration: BoxDecoration(color: getColorFromHex('#495AB2'), borderRadius: const BorderRadius.all(Radius.circular(10))),
            //   alignment: Alignment.center,
            //   padding: const EdgeInsets.symmetric(vertical: 10),
            //   margin: const EdgeInsets.symmetric(horizontal: 16),
            //   child: getTextWidgetMaxLines(
            //       "${AppLocalizations.of(context)!.translate('tap_to_update')!} / ${AppLocalizations.of(context)!.translate('long_press_delete')!}",
            //       16,
            //       getColorFromHex('#FFFFFF'),
            //       FontWeight.w700,
            //       TextAlign.center,
            //       FontUtil.ROBOTOBOLD, 1),
            // ),

            const SizedBox(height: 36),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [

                  Container(
                    alignment: Alignment.centerLeft,
                    child: getTextWidgetMaxLines(
                        AppLocalizations.of(context)!.translate('add_coins')!,
                        16,
                        getColorFromHex('#2B2D33'),
                        FontWeight.w500,
                        TextAlign.center,
                        FontUtil.ROBOTOMEDIUM, 1),
                  ),

                  const Spacer(),

                  Container(
                    alignment: Alignment.centerRight,
                    child: getTextWidgetMaxLines(
                        AppLocalizations.of(context)!.translate('add')!,
                        16,
                        getColorFromHex('#2B2D33'),
                        FontWeight.w500,
                        TextAlign.center,
                        FontUtil.ROBOTOMEDIUM, 1),
                  ),

                ],
              ),
            ),

            Expanded(
              child: items.isEmpty?Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CoinsScreen(bitcoinList,widget.ApiUrl)));
                      },
                    child: Container(
                      alignment: Alignment.center,
                      width: 200,
                      height: 60,
                      decoration: BoxDecoration(color: getColorFromHex('#495AB2'), borderRadius: const BorderRadius.all(Radius.circular(10))),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: getTextWidgetMaxLines(
                          AppLocalizations.of(context)!.translate('add_coins')!,
                          16,
                          getColorFromHex('#FFFFFF'),
                          FontWeight.w500,
                          TextAlign.center,
                          FontUtil.ROBOTOMEDIUM, 1),
                    ),
                  ),
                ],
              ) :Showcase(
                key: _key0,
                // title: 'Tap to Add Coin',
                description:
                'Tap here to update/ Long Press to Delete',
                textColor: Colors.black,
                child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(
                      items.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),

                      decoration: BoxDecoration(color: index%2!=0?getColorFromHex('#FBEEEE'):getColorFromHex('#DCEDEC'), borderRadius: const BorderRadius.all(Radius.circular(14))),
                      child: Stack(
                        children: [
                          InkWell(
                            onLongPress: () {
                              setState(() {
                                // onLongPressed = true;
                                print("deleteVisible");
                                totalValuesOfPortfolio02 = items[index].totalValue;
                                totalValuesOfPortfolio03 = totalValuesOfPortfolio;
                                _showdeleteCoinFromPortfolioDialog(items[index]);
                              });
                            },

                            onTap: () {
                              totalValuesOfPortfolio02 = items[index].totalValue;
                              totalValuesOfPortfolio03 = totalValuesOfPortfolio;
                              showPortfolioEditDialog(items[index]);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  SizedBox(
                                      height: 52,
                                      width: 52,
                                      child: FadeInImage(
                                        placeholder: const AssetImage('assets/images/coin_background_icon.png'),
                                        image: NetworkImage("${widget.ApiUrl}/Bitcoin/resources/icons/${items[index].name?.toLowerCase()}.png"),
                                      )
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: getTextWidgetMaxLines(
                                            items[index].name??'',
                                            12,
                                            getColorFromHex('#000000'),
                                            FontWeight.w500,
                                            TextAlign.center,
                                            FontUtil.ROBOTOMEDIUM, 1),
                                      ),
                                      Container(
                                        child: getTextWidgetMaxLines(
                                            items[index].numberOfCoins.toStringAsFixed(2),
                                            12,
                                            getColorFromHex('#000000'),
                                            FontWeight.w500,
                                            TextAlign.center,
                                            FontUtil.ROBOTOMEDIUM, 1),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    child: getTextWidgetMaxLines(
                                        items[index].totalValue.toStringAsFixed(2),
                                        20,
                                        getColorFromHex('#000000'),
                                        FontWeight.w500,
                                        TextAlign.center,
                                        FontUtil.ROBOTOMEDIUM, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // InkWell(
                          //   onTap: () {
                          //     print("deleteVisible");
                          //     totalValuesOfPortfolio02 = items[index].totalValue;
                          //     totalValuesOfPortfolio03 = totalValuesOfPortfolio;
                          //     _showdeleteCoinFromPortfolioDialog(items[index]);
                          //     },
                          //   onLongPress: () {
                          //     setState(() {
                          //       onLongPressed = false;
                          //     });
                          //     },
                          //
                          //
                          //   child: Visibility(
                          //     visible: onLongPressed,
                          //     child: Container(
                          //       alignment: Alignment.center,
                          //       decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: const BorderRadius.all(Radius.circular(14))),
                          //       child: Image.asset('assets/images/portfolio-delete_icon.png', width: 41, height: 50),
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),

          ],
        ),
      ),
    );}));
  }


  void _showdeleteCoinFromPortfolioDialog(PortfolioBitcoin item) {
    showCupertinoModalPopup(
        context: context,
        builder: (ctxt) => Container(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            backgroundColor: getDarkBackground(),
            body: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Image.asset("assets/images/back_arrow_icon.png",height: 18,width: 18, color: getColorFromHex('#2B2D33')),
                          ),
                        ),

                        Container(
                          alignment: Alignment.center,
                          child: getTextWidgetMaxLines(
                              AppLocalizations.of(context)!.translate('remove_coins')!,
                              16,
                              getColorFromHex('#2B2D33'),
                              FontWeight.w700,
                              TextAlign.center,
                              FontUtil.ROBOTOBOLD, 1),
                        ),

                        const SizedBox(
                          width: 18,
                          height: 18,
                        )
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top:50),
                    child: Text(AppLocalizations.of(context)!.translate('do_you')!,
                      style: TextStyle(fontSize: 22, color: getColorFromHex('#2B2D33'), fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  ),

                  const SizedBox(height: 50),

                  Container(
                    decoration: BoxDecoration(
                      color: getColorFromHex("#586CD0"),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        FadeInImage(
                          placeholder: const AssetImage('assets/images/coin_background_icon.png'),
                          image: NetworkImage("${widget.ApiUrl}/Bitcoin/resources/icons/${item.name.toLowerCase()}.png"),
                          height: 52,
                          width: 52,
                        ),
                        const SizedBox(
                            width:10
                        ),
                        Text(item.name,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),)
                      ],
                    ),
                  ),

                  const Spacer(),

                  InkWell(
                    onTap: () {
                      _deleteCoinsToLocalStorage(item, onTap: (price) {
                        items.clear();
                        if(!price) {
                          print(price);
                          dbHelper.queryAllRows().then((notes) {
                            if(notes.isEmpty) {
                              print(notes.length);
                              setState(() {
                                totalValuesOfPortfolio = 0.0;
                              });
                            }
                            else {
                              notes.forEach((note) {
                                items.add(PortfolioBitcoin.fromMap(note));
                                totalValuesOfPortfolio04 = totalValuesOfPortfolio03 - totalValuesOfPortfolio02;
                                totalValuesOfPortfolio = 0.0;
                                totalValuesOfPortfolio = totalValuesOfPortfolio04;
                              });
                              setState(() {});
                            }
                          });
                        }
                      });
                    },

                    child: Container(
                        padding: const EdgeInsets.fromLTRB(35, 15, 35, 15),
                        decoration: BoxDecoration(
                          color: getColorFromHex("#586CD0"),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:  Text(AppLocalizations.of(context)!.translate('remove_coins')!,style:GoogleFonts.poppins(textStyle:const TextStyle(color: Colors.white, fontWeight:FontWeight.bold,fontSize: 18)),textAlign: TextAlign.start,)
                    ),
                  ),

                  const SizedBox(height: 40)
                ],
              ),
            ),
          ),
        )
    );
  }


  _deleteCoinsToLocalStorage(PortfolioBitcoin item, {required Function(bool valuePrice) onTap}) async {
    final id = await dbHelper.delete(item.name);
    print('inserted row id: $id');
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences!.setInt("index", 3);
      sharedPreferences!.setString("title", AppLocalizations.of(context)!.translate('coins') ?? '');
      sharedPreferences!.commit();
    });
    onTap(false);
    Navigator.pop(context);
  }


  Future<void> showPortfolioEditDialog(PortfolioBitcoin bitcoin) async {
    coinCountEditTextEditingController!.text = bitcoin.numberOfCoins.toInt().toString();
    showCupertinoModalPopup(
        context: context,
        builder: (ctxt) => Container(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            backgroundColor: getDarkBackground(),
            body: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [


                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Image.asset("assets/images/back_arrow_icon.png",height: 18,width: 18, color: getColorFromHex('#2B2D33')),
                          ),
                        ),

                        Container(
                          alignment: Alignment.center,
                          child: getTextWidgetMaxLines(
                              AppLocalizations.of(context)!.translate('update_coins')!,
                              16,
                              getColorFromHex('#2B2D33'),
                              FontWeight.w700,
                              TextAlign.center,
                              FontUtil.ROBOTOBOLD, 1),
                        ),

                        const SizedBox(
                          width: 18,
                          height: 18,
                        )
                      ],
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: getColorFromHex("#586CD0"),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: 80,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child:Row(children: [
                      FadeInImage(
                        placeholder: const AssetImage('assets/images/coin_background_icon.png'),
                        image: NetworkImage("${widget.ApiUrl}/Bitcoin/resources/icons/${bitcoin.name.toLowerCase()}.png"),
                        height: 52,
                        width: 52,
                      ),
                      const SizedBox(
                          width:10
                      ),
                      Text(bitcoin.name,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),),

                      const Spacer(),
                      Text('\$ ${bitcoin.totalValue.toStringAsFixed(2)}',style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 17,fontWeight: FontWeight.normal,color: Colors.white)),),

                    ],),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: getColorFromHex("#FFFFFF"),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: getColorFromHex('#586CD0'))
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,

                    child: TextFormField(
                      key: _formKey,
                      controller: coinCountEditTextEditingController,
                      style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),textAlign: TextAlign.start,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
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
                  const Spacer(),
                  InkWell(
                    onTap: (){
                      _updateSaveCoinsToLocalStorage(bitcoin, onTap: (price, secondPrice) {

                        items.clear();
                        if(!price) {
                          dbHelper.queryAllRows().then((notes) {
                            notes.forEach((note) {
                              items.add(PortfolioBitcoin.fromMap(note));
                              totalValuesOfPortfolio04 = totalValuesOfPortfolio03 - totalValuesOfPortfolio02;
                              totalValuesOfPortfolio = 0.0;
                              totalValuesOfPortfolio = totalValuesOfPortfolio04 + secondPrice;
                            });
                            setState(() {});
                          });
                        }
                      });
                    },
                    child: Container(
                        padding: EdgeInsets.fromLTRB(35, 15, 35, 15),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        decoration: BoxDecoration(
                          color: getColorFromHex("#586CD0"),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:  Text(AppLocalizations.of(context)!.translate('update_coins')!,style:GoogleFonts.poppins(textStyle:const TextStyle(color: Colors.white, fontWeight:FontWeight.bold,fontSize: 18)),textAlign: TextAlign.start,)
                    ),
                  ),
                  const SizedBox(height: 40,),
                ],
              ),
            ),
          ),
        )
    );
  }


  _updateSaveCoinsToLocalStorage(PortfolioBitcoin bitcoin, {required Function(bool valuePrice, double secondValue) onTap}) async {
    if(coinCountEditTextEditingController!.text.isNotEmpty && coinCountEditTextEditingController!.text!=0){
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
        sharedPreferences!.setString("title", AppLocalizations.of(context)!.translate('portfolio') ?? '');
        sharedPreferences!.commit();
      });
      onTap(false, (adf) * (bitcoin.rateDuringAdding));
      Navigator.pop(context);
      // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => PortfolioScreen(widget.gainerLooserCoinList)), (route) => false);

    }
  }


  Future<void> getCoinsList() async {
    var uri = 'http://144.91.65.218:8085/Bitcoin/resources/getBitcoinCryptoListLoser?size=0&currency=USD';
    var response = await get(Uri.parse(uri));
    final data = json.decode(response.body) as Map;

    if (data['error'] == false) {
      setState(() {
        bitcoinList.addAll(data['data']
            .map<Bitcoin>((json) => Bitcoin.fromJson(json))
            .toList());
      });
    } else {
      setState(() {});
    }
  }

}