
// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:bitcoinproapp/Ui/AddCoinScreen.dart';
import 'package:bitcoinproapp/Util/color_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../Models/Bitcoin.dart';
import '../Util/app_localizations.dart';
import '../Util/font_util.dart';
import '../Util/text_widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class TrendScreen extends StatefulWidget {
  Bitcoin bitcoinList;
  String ?ApiUrl;
  TrendScreen(this.bitcoinList, this.ApiUrl, {super.key});
  @override
  TrendScreenState createState() => TrendScreenState();
}


class TrendScreenState extends State<TrendScreen> {
  int indexClick = 0;
  int buttonType = 3;
  String _type = "Week";
  List<LinearSales> currencyData = [];
  late String currencyNameForImage;
  List<Bitcoin> trendBitcoinList = [];
  String name = "";
  double coin = 0;
  String result = '';
  double diffRate = 0;
  bool isLoading = false;



  @override
  void initState() {
    callTrendBitcoinApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getDarkBackground(),
      body: SafeArea(
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
                              AppLocalizations.of(context)!.translate('trends')!,
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
                                image: NetworkImage("http://144.91.65.218:8085/Bitcoin/resources/icons/${currencyNameForImage.toLowerCase()}.png"),
                              )
                          ),

                          const SizedBox(width: 10),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: getTextWidgetMaxLines(
                                    name,
                                    12,
                                    getColorFromHex('#FFFFFF'),
                                    FontWeight.w500, TextAlign.center, FontUtil.ROBOTOMEDIUM, 1),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                child: getTextWidgetMaxLines(
                                    "$coin $name",
                                    20,
                                    getColorFromHex("#FFFFFF"),
                                    FontWeight.w500, TextAlign.center, FontUtil.ROBOTOMEDIUM, 1),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    child: getTextWidgetMaxLines(
                                        '$diffRate',
                                        12,
                                        double.parse(widget.bitcoinList.diffRate!)<0?getColorFromHex("#FF5858"):getColorFromHex('#2AD28D'),
                                        FontWeight.w400, TextAlign.center, FontUtil.ROBOTOREGULAR, 1),
                                  ),
                                  const SizedBox(width: 4),
                                  Image.asset(double.parse(widget.bitcoinList.diffRate!)<0?'assets/images/down_arrow.png':'assets/images/up_arrow.png', height: 10)
                                ],
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    buttonType = 3;
                    _type = "4Day";
                    callTrendBitcoinApi();
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 30,
                        alignment: Alignment.center,
                        child: getTextWidgetMaxLines(
                            '4 Day', 12,
                            getColorFromHex('#757575'), FontWeight.w500, TextAlign.center, FontUtil.ROBOTOMEDIUM, 1),
                      ),

                      Container(height: 2, width: 50, color: buttonType==3?getColorFromHex('#586CD0'):getDarkBackground())

                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    buttonType = 4;
                    _type = "Week";
                    callTrendBitcoinApi();
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 30,
                        alignment: Alignment.center,
                        child: getTextWidgetMaxLines(
                            'Week', 12,
                            getColorFromHex('#757575'), FontWeight.w500, TextAlign.center, FontUtil.ROBOTOMEDIUM, 1),
                      ),

                      Container(height: 2, width: 50, color: buttonType==4?getColorFromHex('#586CD0'):getDarkBackground())

                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    buttonType = 5;
                    _type = "15Day";
                    callTrendBitcoinApi();
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 30,
                        alignment: Alignment.center,
                        child: getTextWidgetMaxLines(
                            '15 Day', 12,
                            getColorFromHex('#757575'), FontWeight.w500, TextAlign.center, FontUtil.ROBOTOMEDIUM, 1),
                      ),

                      Container(height: 2, width: 50, color: buttonType==5?getColorFromHex('#586CD0'):getDarkBackground())

                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    buttonType = 6;
                    _type = "Month";
                    callTrendBitcoinApi();
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 30,
                        alignment: Alignment.center,
                        child: getTextWidgetMaxLines(
                            'Month', 12,
                            getColorFromHex('#757575'), FontWeight.w500, TextAlign.center, FontUtil.ROBOTOMEDIUM, 1),
                      ),
                      Container(height: 2, width: 50, color: buttonType==6?getColorFromHex('#586CD0'):getDarkBackground())
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    buttonType = 7;
                    _type = "2Month";
                    callTrendBitcoinApi();
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 30,
                        alignment: Alignment.center,
                        child: getTextWidgetMaxLines(
                            '2 Month', 12,
                            getColorFromHex('#757575'), FontWeight.w500, TextAlign.center, FontUtil.ROBOTOMEDIUM, 1),
                      ),

                      Container(height: 2, width: 50, color: buttonType==7?getColorFromHex('#586CD0'):getDarkBackground())

                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    buttonType = 8;
                    _type = "Year";
                    callTrendBitcoinApi();
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 30,
                        alignment: Alignment.center,
                        child: getTextWidgetMaxLines(
                            'Year', 12,
                            getColorFromHex('#757575'), FontWeight.w500, TextAlign.center, FontUtil.ROBOTOMEDIUM, 1),
                      ),
                      Container(height: 2, width: 50, color: buttonType==8?getColorFromHex('#586CD0'):getDarkBackground())

                    ],
                  ),
                ),

              ],
            ),

            const SizedBox(height: 24),

            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: getColorFromHex('#FFFFFF'), borderRadius: const BorderRadius.all(Radius.circular(14))),
                child: !isLoading?Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          SizedBox(
                            child: charts.LineChart(
                              _createSampleDataTrend(),
                              layoutConfig: charts.LayoutConfig(
                                  leftMarginSpec: charts.MarginSpec.fixedPixel(5),
                                  topMarginSpec: charts.MarginSpec.fixedPixel(10),
                                  rightMarginSpec: charts.MarginSpec.fixedPixel(5),
                                  bottomMarginSpec: charts.MarginSpec.fixedPixel(10)),
                              defaultRenderer: charts.LineRendererConfig(includeArea: true, stacked: true,),
                              animate: true,
                              domainAxis: const charts.NumericAxisSpec(showAxisLine: false, renderSpec: charts.NoneRenderSpec()),
                              primaryMeasureAxis: const charts.NumericAxisSpec(renderSpec: charts.NoneRenderSpec()),
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                              onTap: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddCoinScreen(widget.bitcoinList,widget.ApiUrl)));
                              },
                              child: Container(
                                height: 48,
                                width: 186,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 36),
                                decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(24)), color: getColorFromHex('#586CD0')),
                                child: getTextWidgetMaxLines(
                                    AppLocalizations.of(context)!.translate('add_coins')!,
                                    12, getColorFromHex('#FFFFFF'),
                                    FontWeight.w700,
                                    TextAlign.center,
                                    FontUtil.ROBOTOBOLD, 1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ):const Center(child: CircularProgressIndicator(),),
              ),
            ),

            const SizedBox(height: 24),

          ],
        ),
      ),
    );
  }

  List<charts.Series<LinearSales, double>> _createSampleDataTrend() {
    return [
      charts.Series<LinearSales, double>(
        id: 'Tablet',
        // colorFn specifies that the line will be red.
        colorFn: (_, __) => diffRate >= 0
            ? charts.MaterialPalette.green.shadeDefault
            : charts.MaterialPalette.red.shadeDefault,
        // areaColorFn specifies that the area skirt will be light red.
        // areaColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.lighter,

        domainFn: (LinearSales sales, _) => sales.date,
        measureFn: (LinearSales sales, _) => sales.rate,
        labelAccessorFn: (LinearSales sales, _) =>
            sales.date.toDouble().toString(),
        data: currencyData,
      ),
    ];
  }

  Future<void> callTrendBitcoinApi() async {
    isLoading = true;
    var currencyName = widget.bitcoinList.symbol?? 'BTC';
    currencyNameForImage = currencyName;
    var uri = 'http://144.91.65.218:8085/Bitcoin/resources/getBitcoinCryptoGraph?type=$_type&name=$currencyNameForImage&currency=USD';
    var response = await get(Uri.parse(uri));
    final data = json.decode(response.body) as Map;
    if (data['error'] == false) {
      setState(() {
        trendBitcoinList = data['data']
            .map<Bitcoin>((json) => Bitcoin.fromJson(json))
            .toList();
        double count = 0;
        diffRate = double.parse(data['diffRate']);
        if (diffRate < 0) {
          result = data['diffRate'].replaceAll("-", "");
        } else {
          result = data['diffRate'];
        }

        currencyData = [];
        for (var element in trendBitcoinList) {
          currencyData.add(LinearSales(count, element.rate!));
          name = element.name!;
          String step2 = element.rate!.toStringAsFixed(2);
          double step3 = double.parse(step2);
          coin = step3;
          count = count + 1;
        }
      });
      isLoading = false;
    } else {

    }
  }
}

class LinearSales {
  final double date;
  final double rate;
  LinearSales(this.date, this.rate);
}
