
// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:bitcoinproapp/Util/color_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../Models/Bitcoin.dart';
import '../Models/PortfolioBitcoin.dart';
import '../Models/TopCoinData.dart';
import '../Util/app_localizations.dart';
import '../Util/dashboard_helper.dart';
import '../Util/font_util.dart';
import '../Util/text_widgets.dart';
import 'PortfolioScreen.dart';
import 'TrendScreen.dart';


class TopCoinsScreen extends StatefulWidget {
  List<Bitcoin> bitcoinList;
  String ?ApiUrl;
  TopCoinsScreen(this.bitcoinList, this.ApiUrl, {super.key});
  @override
  TopCoinsScreenState createState() => TopCoinsScreenState();
}


class TopCoinsScreenState extends State<TopCoinsScreen> {

  bool isLoading = false;
  List<TopCoinData> topCoinList = [];
  var listLooser=[];
  var listGainer=[];
  double totalValuesOfPortfolio = 0.0;
  final dbHelper = DatabaseHelper.instance;
  List<PortfolioBitcoin> items = [];

  @override
  void initState() {
    callTopBitCoinApi();
    dbHelper.queryAllRows().then((notes) {
      notes.forEach((note) {
        items.add(PortfolioBitcoin.fromMap(note));
        totalValuesOfPortfolio = totalValuesOfPortfolio + note["total_value"];
      });
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getDarkBackground(),
      body: SafeArea(
        child: !isLoading?Column(
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
                              AppLocalizations.of(context)!.translate('top_coins')!,
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

                  const SizedBox(height: 24),

                  Container(
                    alignment: Alignment.center,
                    child: getTextWidgetMaxLines(
                        AppLocalizations.of(context)!.translate('your_portfolio')!,
                        12,
                        getColorFromHex('#FFFFFF'),
                        FontWeight.w500,
                        TextAlign.center,
                        FontUtil.ROBOTOMEDIUM, 1),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    alignment: Alignment.center,
                    child: getTextWidgetMaxLines(
                        '\$ ${totalValuesOfPortfolio.toStringAsFixed(2)}',
                        34,
                        getColorFromHex('#FFFFFF'),
                        FontWeight.w500,
                        TextAlign.center,
                        FontUtil.ROBOTOMEDIUM, 1),
                  ),

                  const SizedBox(height: 24),

                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PortfolioScreen(widget.ApiUrl)));
                    },
                    child: Container(
                      width: 186,
                      height: 48,
                      decoration: BoxDecoration(color: getColorFromHex('#4A5AA9'), borderRadius: const BorderRadius.all(Radius.circular(24))),
                      alignment: Alignment.center,
                      child: getTextWidgetMaxLines(
                          AppLocalizations.of(context)!.translate('view')!,
                          12,
                          getColorFromHex('#FFFFFF'),
                          FontWeight.w700,
                          TextAlign.center,
                          FontUtil.ROBOTOBOLD, 1),
                    ),
                  ),

                  const SizedBox(height: 50),

                ],
              ),
            ),

            const SizedBox(height: 36),

            Container(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: getTextWidgetMaxLines(
                        AppLocalizations.of(context)!.translate('top_looser')!,
                        16,
                        getColorFromHex('#2B2D33'),
                        FontWeight.w500,
                        TextAlign.center,
                        FontUtil.ROBOTOMEDIUM, 1),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 96,
                    child: listLooser.isEmpty?Container(
                      alignment: Alignment.center,
                      child: getTextWidgetMaxLines(
                          AppLocalizations.of(context)!.translate('looser_list_empty')!,
                          16,
                          getColorFromHex('#2B2D33'),
                          FontWeight.w500,
                          TextAlign.center,
                          FontUtil.ROBOTOMEDIUM, 1),
                    ): ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: listLooser.length,
                        itemBuilder: (BuildContext context, int index) {
                      return  InkWell(
                        onTap: () {
                          int selectIn = 0;
                          for(int k=0; k<widget.bitcoinList.length; k++) {
                            if(widget.bitcoinList[k].name==listLooser[index].name) {
                              selectIn = k;
                            }
                          }
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TrendScreen(widget.bitcoinList[selectIn],widget.ApiUrl)));
                        },
                        child: Container(
                          height: 96,
                          width: 320,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(color: getColorFromHex('#FFFFFF'), borderRadius: const BorderRadius.all(Radius.circular(14))),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                  height: 52,
                                  width: 52,
                                  child: FadeInImage(
                                    placeholder: const AssetImage('assets/images/coin_background_icon.png'),
                                    image: NetworkImage('${listLooser[index].icon}'),
                                  )
                              ),

                              const SizedBox(width: 10),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: getTextWidgetMaxLines(
                                        '${listLooser[index].symbol}',
                                        12,
                                        getColorFromHex('#000000'),
                                        FontWeight.w500, TextAlign.center, FontUtil.ROBOTOMEDIUM, 1),
                                  ),

                                  const SizedBox(height: 4),

                                  Container(
                                    child: getTextWidgetMaxLines(
                                        "${(listLooser[index].rate)!.toStringAsFixed(2)}",
                                        20,
                                        getColorFromHex("#000000"),
                                        FontWeight.w500, TextAlign.center, FontUtil.ROBOTOMEDIUM, 1),
                                  ),
                                ],
                              ),

                            ],
                          ),

                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: getTextWidgetMaxLines(
                        AppLocalizations.of(context)!.translate('top_gainer')!,
                        16,
                        getColorFromHex('#2B2D33'),
                        FontWeight.w500,
                        TextAlign.center,
                        FontUtil.ROBOTOMEDIUM, 1),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 96,
                    child: listGainer.isEmpty?Container(
                      alignment: Alignment.center,
                      child: getTextWidgetMaxLines(
                          AppLocalizations.of(context)!.translate('gainer_list_empty')!,
                          16,
                          getColorFromHex('#2B2D33'),
                          FontWeight.w500,
                          TextAlign.center,
                          FontUtil.ROBOTOMEDIUM, 1),
                    ) :ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: listGainer.length,
                        itemBuilder: (BuildContext context, int index) {
                          return  InkWell(
                            onTap: () {
                              int selectIn = 0;
                              for(int k=0; k<widget.bitcoinList.length; k++) {
                                if(widget.bitcoinList[k].name==listGainer[index].name) {
                                  selectIn = k;
                                }
                              }
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TrendScreen(widget.bitcoinList[selectIn],widget.ApiUrl)));
                            },
                            child: Container(
                              height: 96,
                              width: 320,
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(color: index%2!=0?getColorFromHex('#586CD0'):getColorFromHex('#2AD28D'), borderRadius: const BorderRadius.all(Radius.circular(14))),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                      height: 52,
                                      width: 52,
                                      child: FadeInImage(
                                        placeholder: const AssetImage('assets/images/coin_background_icon.png'),
                                        image: NetworkImage('${listGainer[index].icon}'),
                                      )
                                  ),

                                  const SizedBox(width: 10),

                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: getTextWidgetMaxLines(
                                            '${listGainer[index].symbol}',
                                            12,
                                            getColorFromHex('#FFFFFF'),
                                            FontWeight.w500, TextAlign.center, FontUtil.ROBOTOMEDIUM, 1),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        child: getTextWidgetMaxLines(
                                            "${(listGainer[index].rate)!.toStringAsFixed(2)}",
                                            20,
                                            getColorFromHex("#FFFFFF"),
                                            FontWeight.w500, TextAlign.center, FontUtil.ROBOTOMEDIUM, 1),
                                      ),
                                    ],
                                  ),

                                ],
                              ),

                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ):const Center(child: CircularProgressIndicator(),),
      ),
    );
  }


  Future<void> callTopBitCoinApi() async {
    isLoading = true;
    var uri = 'http://144.91.65.218:8085/Bitcoin/resources/getBitcoinCryptoListLoser?size=0&currency=USD';
    var response = await get(Uri.parse(uri));
    final data = json.decode(response.body) as Map;
    if (data['error'] == false) {
      setState(() {
        topCoinList.addAll(data['data']
            .map<TopCoinData>((json) => TopCoinData.fromJson(json))
            .toList());

        listLooser.clear();
        listLooser = topCoinList.where((element) => double.parse(element.diffRate!) < 0).toList();
        print(listLooser.length);

        listGainer.clear();
        listGainer = topCoinList.where((element) => double.parse(element.diffRate!) >= 0).toList();
        print(listGainer.length);

      });
      isLoading = false;
    } else {
      setState(() {});
    }
  }
}

