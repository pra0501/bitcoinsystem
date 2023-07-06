
// ignore_for_file: depend_on_referenced_packages

import 'package:bitcoinproapp/Util/color_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/Bitcoin.dart';
import '../Models/PortfolioBitcoin.dart';
import '../Util/app_localizations.dart';
import '../Util/dashboard_helper.dart';
import '../Util/font_util.dart';
import '../Util/text_widgets.dart';
import 'package:collection/collection.dart';
import 'PortfolioScreen.dart';


class AddCoinScreen extends StatefulWidget {
  Bitcoin bitcoinList;
  String ?ApiUrl;
  AddCoinScreen(this.bitcoinList, this.ApiUrl, {super.key});
  @override
  AddCoinScreenState createState() => AddCoinScreenState();
}


class AddCoinScreenState extends State<AddCoinScreen> {
  TextEditingController? coinCountTextEditingController;

  List<int> coinQuantityList = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1100, 1200];
  int selectedIndex = 0;
  final _formKey2 = GlobalKey<FormState>();
  List<PortfolioBitcoin> items = [];
  final dbHelper = DatabaseHelper.instance;
  SharedPreferences? sharedPreferences;
  double totalValuesOfPortfolio = 0.0;


  @override
  void initState() {
    coinCountTextEditingController = TextEditingController();
    dbHelper.queryAllRows().then((notes) {
      for (var note in notes) {
        items.add(PortfolioBitcoin.fromMap(note));
        totalValuesOfPortfolio = totalValuesOfPortfolio + note["total_value"];
      }
      setState(() {});
    });
    setState(() {
      coinCountTextEditingController!.text = coinQuantityList[selectedIndex].toString();
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getDarkBackground(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                    color: getColorFromHex('#586CD0')
                ),
                child: Column(
                  children: [

                    SizedBox(
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
                              child: Image.asset("assets/images/back_arrow_icon.png",height: 18,width: 18),
                            ),
                          ),

                          Container(
                            alignment: Alignment.center,
                            child: getTextWidgetMaxLines(
                                AppLocalizations.of(context)!.translate('add_coins')!,
                                16,
                                getColorFromHex('#FFFFFF'),
                                FontWeight.w700,
                                TextAlign.center,
                                FontUtil.ROBOTOBOLD, 1),
                          ),

                          const SizedBox(
                            height: 18,
                            width: 18
                          ),
                        ],
                      ),
                    ),

                    Container(
                      height: 96,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(30),),
                          color: getColorFromHex('#495AB2')
                      ),

                      child: Container(
                        height: 86,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                                height: 52,
                                width: 52,
                                child: FadeInImage(
                                  placeholder: const AssetImage('assets/images/coin_background_icon.png'),
                                  image: NetworkImage("${widget.ApiUrl}/Bitcoin/resources/icons/${widget.bitcoinList.name?.toLowerCase()}.png"),
                                )
                            ),

                            const SizedBox(width: 10),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: getTextWidgetMaxLines(
                                      '${widget.bitcoinList.name}',
                                      12,
                                      getColorFromHex('#FFFFFF'),
                                      FontWeight.w500, TextAlign.center, FontUtil.ROBOTOMEDIUM, 1),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  child: getTextWidgetMaxLines(
                                      "${(widget.bitcoinList.rate)!.toStringAsFixed(2)} ${widget.bitcoinList.name!}",
                                      20,
                                      getColorFromHex("#FFFFFF"),
                                      FontWeight.w500, TextAlign.center, FontUtil.ROBOTOMEDIUM, 1),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  child: getTextWidgetMaxLines(
                                      '${widget.bitcoinList.perRate}',
                                      12,
                                      double.parse(widget.bitcoinList.diffRate!)<0?getColorFromHex("#FF5858"):getColorFromHex('#2AD28D'),
                                      FontWeight.w400, TextAlign.center, FontUtil.ROBOTOREGULAR, 1),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 36),

              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 273,
                    decoration: BoxDecoration(color: getColorFromHex('#FFFFFF'), borderRadius: const BorderRadius.all(Radius.circular(14))),
                    child:  Column(
                      children: [
                        const SizedBox(height: 10),

                        Container(
                          height: 60,
                          alignment: Alignment.center,
                          child: Form(
                            key: _formKey2,
                            child: TextFormField(
                              controller: coinCountTextEditingController,
                              style: const TextStyle(fontSize: 40,fontWeight: FontWeight.w500,color: Colors.black, fontFamily: FontUtil.ROBOTOMEDIUM),
                              textAlign: TextAlign.center,
                              cursorColor: Colors.white,
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 40, fontFamily: FontUtil.ROBOTOMEDIUM),
                                hintText:'',
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Container(
                          child: getTextWidgetMaxLinesSpaces(
                              AppLocalizations.of(context)!.translate('enter_coins')!,
                              12,
                              getColorFromHex('#757575'),
                              FontWeight.w400, TextAlign.center, FontUtil.ROBOTOREGULAR, 1, 1.5),
                        ),

                        const SizedBox(height: 10),

                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 4,
                            childAspectRatio: 3/1.8,
                            children: List.generate(
                                coinQuantityList.length, (index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = index;
                                    coinCountTextEditingController?.text = coinQuantityList[selectedIndex].toString();
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                  decoration: BoxDecoration(color: selectedIndex==index?getColorFromHex('#2AD28D'):getColorFromHex('#F3F4F5'), borderRadius: const BorderRadius.all(Radius.circular(6))),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: getTextWidgetMaxLines(
                                        coinQuantityList[index].toString()??"",
                                        12,
                                        selectedIndex==index?getColorFromHex('#FFFFFF'):getColorFromHex('#757575'),
                                        FontWeight.w500,
                                        TextAlign.center,
                                        FontUtil.ROBOTOMEDIUM, 1),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),

                      ],
                    ),


                  ),
                ],
              ),

              const SizedBox(height: 150),
            ],
          ),
        ),
      ),

      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: FloatingActionButton.extended(
          backgroundColor: getColorFromHex('#586CD0'),
          onPressed: () {
            _addSaveCoinsToLocalStorage(widget.bitcoinList);
          },
          label: Container(
            child: getTextWidgetMaxLines(
                AppLocalizations.of(context)!.translate('add')!,
                12,
                getColorFromHex('#FFFFFF'),
                FontWeight.w700,
                TextAlign.center,
                FontUtil.ROBOTOBOLD, 1),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }


  _addSaveCoinsToLocalStorage(Bitcoin bitcoin) async {
    if (_formKey2.currentState!.validate()) {
      if (items != null && items.length > 0) {
        PortfolioBitcoin? bitcoinLocal = items.firstWhereOrNull((element) => element.name == bitcoin.name);

        if (bitcoinLocal != null) {
          Map<String, dynamic> row = {
            DatabaseHelper.columnName: bitcoin.name,
            DatabaseHelper.columnRateDuringAdding: bitcoin.rate,
            DatabaseHelper.columnCoinsQuantity:
            double.parse(coinCountTextEditingController!.value.text) +
                bitcoinLocal.numberOfCoins,
            DatabaseHelper.columnTotalValue:
            double.parse(coinCountTextEditingController!.value.text) *
                (bitcoin.rate!) +
                bitcoinLocal.totalValue,
          };
          final id = await dbHelper.update(row);
          print('inserted row id: $id');
        } else {
          Map<String, dynamic> row = {
            DatabaseHelper.columnName: bitcoin.name,
            DatabaseHelper.columnRateDuringAdding: bitcoin.rate,
            DatabaseHelper.columnCoinsQuantity:
            double.parse(coinCountTextEditingController!.value.text),
            DatabaseHelper.columnTotalValue:
            double.parse(coinCountTextEditingController!.value.text) *
                (bitcoin.rate!),
          };
          final id = await dbHelper.insert(row);
          print('inserted row id: $id');
        }
      } else {
        Map<String, dynamic> row = {
          DatabaseHelper.columnName: bitcoin.name,
          DatabaseHelper.columnRateDuringAdding: bitcoin.rate,
          DatabaseHelper.columnCoinsQuantity:
          double.parse(coinCountTextEditingController!.text),
          DatabaseHelper.columnTotalValue:
          double.parse(coinCountTextEditingController!.value.text) *
              (bitcoin.rate!),
        };
        final id = await dbHelper.insert(row);
        print('inserted row id: $id');
      }

      sharedPreferences = await SharedPreferences.getInstance();
      setState(() {
        sharedPreferences!.setString("currencyName", bitcoin.name ??'');
        sharedPreferences!.setInt("index", 1);
        sharedPreferences!.setString("title", AppLocalizations.of(context)!.translate('trends') ?? '');
        sharedPreferences!.commit();
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => PortfolioScreen(widget.ApiUrl)));

    } else {}
  }

}