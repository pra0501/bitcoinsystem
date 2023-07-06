


import 'package:bitcoinproapp/Util/color_util.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import '../Models/Bitcoin.dart';
import '../Util/app_localizations.dart';
import '../Util/font_util.dart';
import '../Util/text_widgets.dart';
import 'TrendScreen.dart';

class CoinsScreen extends StatefulWidget {
  List<Bitcoin> bitcoinList;
  String ?ApiUrl;
  CoinsScreen(this.bitcoinList, this.ApiUrl, {super.key});
  @override
  CoinsScreenState createState() => CoinsScreenState();

}

class CoinsScreenState extends State<CoinsScreen> {
  final _key1 = GlobalKey();
  BuildContext? myContext;
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ShowCaseWidget.of(myContext!)!.startShowCase([_key1]);
    });
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
          child: Container(
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
                                  AppLocalizations.of(context)!.translate('coins')!,
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

                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TrendScreen(widget.bitcoinList[0],widget.ApiUrl)));
                        },
                        child: Container(
                          height: 96,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(30)),
                              color: getColorFromHex('#495AB2')
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                  height: 52,
                                  width: 52,
                                  child: FadeInImage(
                                    placeholder: AssetImage('assets/images/coin_background_icon.png'),
                                    image: NetworkImage('${widget.bitcoinList[0].icon}'),
                                  )
                              ),

                              const SizedBox(width: 10),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: getTextWidgetMaxLines(
                                        '${widget.bitcoinList[0].symbol}',
                                        12,
                                        getColorFromHex('#FFFFFF'),
                                        FontWeight.w500, TextAlign.center, FontUtil.ROBOTOMEDIUM, 1),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    child: getTextWidgetMaxLines(
                                        "${(widget.bitcoinList[0].rate)!.toStringAsFixed(2)}",
                                        20,
                                        getColorFromHex("#FFFFFF"),
                                        FontWeight.w500, TextAlign.center, FontUtil.ROBOTOMEDIUM, 1),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    child: getTextWidgetMaxLines(
                                        '${widget.bitcoinList[0].perRate}',
                                        12,
                                        double.parse(widget.bitcoinList[0].diffRate!)<0?getColorFromHex("#FF5858"):getColorFromHex('#2AD28D'),
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
                const SizedBox(height: 24),

          Expanded(
            child: Showcase(
                key: _key1,
                // title: 'Tap to Add Coin',
                description:
                'Tap here to check Trends and Add Coin',
                textColor: Colors.black,

                    child: ListView.builder(
                        itemCount: widget.bitcoinList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return  InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => TrendScreen(widget.bitcoinList[index],widget.ApiUrl)));
                              },
                              child: Container(
                                height: 66,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(14)),
                                    color: getColorFromHex('#FFFFFF')
                                ),

                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                        height: 52,
                                        width: 52,
                                        child: FadeInImage(
                                          placeholder: AssetImage('assets/images/coin_background_icon.png'),
                                          image: NetworkImage('${widget.bitcoinList[index].icon}'),
                                        )
                                    ),

                                    const SizedBox(width: 10),

                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: getTextWidgetMaxLines(
                                              '${widget.bitcoinList[index].symbol}',
                                              12,
                                              getColorFromHex('#000000'),
                                              FontWeight.w500, TextAlign.center, FontUtil.ROBOTOMEDIUM, 1),
                                        ),
                                        const SizedBox(height: 4),
                                        Container(
                                          child: getTextWidgetMaxLines(
                                              "${(widget.bitcoinList[index].rate)!.toStringAsFixed(2)}",
                                              20,
                                              getColorFromHex("#586CD0"),
                                              FontWeight.w500, TextAlign.center, FontUtil.ROBOTOMEDIUM, 1),
                                        ),
                                      ],
                                    ),

                                    const Spacer(),

                                    Container(
                                      child: getTextWidgetMaxLines(
                                          '${widget.bitcoinList[index].perRate}',
                                          12,
                                          double.parse(widget.bitcoinList[index].diffRate!)<0?getColorFromHex("#FF5858"):getColorFromHex('#2AD28D'),
                                          FontWeight.w500, TextAlign.center, FontUtil.ROBOTOMEDIUM, 1),
                                    ),

                                    const SizedBox(width: 4),

                                    Image.asset(double.parse(
                                        widget.bitcoinList[index].diffRate!)<0?'assets/images/down_arrow.png':'assets/images/up_arrow.png',
                                        height: 12),

                                  ],
                                ),
                              )
                            )
                          ;
                        }),
                  ),
          ),
              ],
            ),

          ),
        ),
      );}),
    );
  }

}