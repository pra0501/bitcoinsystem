// ignore_for_file: deprecated_member_use, import_of_legacy_library_into_null_safe

import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// import 'localization/app_localizations.dart';
import 'portfolio_page.dart';
import 'models/Bitcoin.dart';
import 'models/TopCoinData.dart';

class DashboardNew extends StatefulWidget {
  const DashboardNew({Key? key}) : super(key: key);

  @override
  _DashboardNewState createState() => _DashboardNewState();
}

class _DashboardNewState extends State<DashboardNew> {

  bool isLoading = false;
  List<Bitcoin> bitcoinList = [];
  List<TopCoinData> topCoinList = [];
  List<Bitcoin> gainerLooserCoinList = [];
  List<Bitcoin> _searchResult = [];
  List<chartData> currencyData = [];
  String result = '';
  String name = "";
  double coin = 0;
  SharedPreferences? sharedPreferences;
  TextEditingController _searchController = TextEditingController();
  num _size = 0;
  double diffRate = 0;
  String? URL;

  @override
  void initState() {
    // fetchRemoteValue();
    callTopBitcoinApi();
    super.initState();
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
    callTopBitcoinApi();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Color(0xfff8f8f8),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
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
                        width: 140,
                      ),
                      const Text("Top Coins",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                        textAlign: TextAlign.start,
                      ),
                    ],
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
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: i % 2 == 0 ? const AssetImage('assets/image/Card.png'):
                                        const AssetImage('assets/image/Card1.png')
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
                                          Row(
                                            children: [
                                              double.parse(gainerLooserCoinList[i].diffRate!) < 0 ? Container(
                                                child: const Icon(
                                                  Icons.arrow_drop_down_sharp,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                              )
                                                  : Container(child: const Icon(
                                                Icons.arrow_drop_up_sharp,
                                                color: Colors.green,
                                                size: 20,
                                              ),
                                              ),
                                              const SizedBox(
                                                  width:2
                                              ),
                                              Text(
                                                  gainerLooserCoinList[i].perRate!,
                                                  style: TextStyle(
                                                      fontSize: 20,color: double.parse(gainerLooserCoinList[i].diffRate!) < 0 ? Colors.red : Colors.green)
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
                              callCurrencyDetails(topCoinList[i].name);
                            },
                          );
                        })
                ),

                const SizedBox(
                  height: 10,
                ),
                // Expanded(
                //   child: Container(
                //     child: ListView(
                //       children: <Widget>[
                //         Column(
                //           children: <Widget>[
                //             Padding(
                //               padding: const EdgeInsets.only(top:5.0),
                //               child: Row(
                //                 children: <Widget>[
                //                   Center(
                //                     child: Container(
                //                         // width: MediaQuery.of(context).size.width,
                //                         // height: MediaQuery.of(context).size.height,
                //                         child: SfCartesianChart(
                //                           plotAreaBorderWidth: 0,
                //                           enableAxisAnimation: true,
                //                           enableSideBySideSeriesPlacement: true,
                //                           series:<ChartSeries>[
                //                             SplineSeries<chartData, double>(
                //                               dataSource: currencyData,
                //                               xValueMapper: (chartData data, _) => data.date,
                //                               yValueMapper: (chartData data, _) => data.rate,
                //                               color: Colors.blue,
                //                               dataLabelSettings: const DataLabelSettings(isVisible: true, borderColor: Colors.blue),
                //                               markerSettings: const MarkerSettings(isVisible: true),
                //                             )
                //                           ],
                //                           primaryXAxis: NumericAxis(isVisible: false,),
                //                           primaryYAxis: NumericAxis(isVisible: false,),
                //                         )
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Gainer & Losers",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                        )),
                  ),
                ),
                gainerLooserCoinList.length <= 0
                    ? const Center(child: CircularProgressIndicator())

                    : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: gainerLooserCoinList.length,
                    itemBuilder: (BuildContext context, int i) {
                      return InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.white70, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding:
                              const EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Container(
                                height: 80,
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                            height: 70,
                                            child: Padding(
                                              padding: const EdgeInsets.all(2.0),
                                              child: FadeInImage(
                                                placeholder: const AssetImage('assetsEvo/imagesEvo/cob.png'),
                                                // image: NetworkImage("$URL/Bitcoin/resources/icons/${gainerLooserCoinList[i].name!.toLowerCase()}.png"),
                                                image: NetworkImage("http://45.34.15.25:8080/Bitcoin/resources/icons/${gainerLooserCoinList[i].name!.toLowerCase()}.png"),
                                              ),
                                            )
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                '${gainerLooserCoinList[i].name}',
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.left,
                                              ),
                                              Row(
                                                children: [
                                                  double.parse(gainerLooserCoinList[i].diffRate!) < 0 ? Container(
                                                    child: const Icon(
                                                      Icons.arrow_drop_down_sharp,
                                                      color: Colors.red,
                                                      size: 15,
                                                    ),
                                                  )
                                                      : Container(child: const Icon(
                                                    Icons.arrow_drop_up_sharp,
                                                    color: Colors.green,
                                                    size: 15,
                                                  ),
                                                  ),
                                                  const SizedBox(
                                                      width:2
                                                  ),
                                                  Text(
                                                      gainerLooserCoinList[i].perRate!,
                                                      style: TextStyle(
                                                          fontSize: 15,color: double.parse(gainerLooserCoinList[i].diffRate!) < 0 ? Colors.red : Colors.green)
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                      '\$${double.parse(gainerLooserCoinList[i].rate!.toStringAsFixed(2))}',
                                                      style:
                                                      const TextStyle(fontSize: 18)),
                                                ],
                                              ),

                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          callCurrencyDetails(gainerLooserCoinList[i].name);
                        },
                      );
                    })
                ,
              ],
            ),
          ),
        ));
  }

  Future<void> callBitcoinApi() async {
//    setState(() {
//      isLoading = true;
//    });
//     var uri = '$URL/Bitcoin/resources/getBitcoinHistoryLists?size=0';
    var uri = 'http://45.34.15.25:8080/Bitcoin/resources/getBitcoinHistoryLists?size=0';

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
    callTopBitcoinApi();
  }

  Future<void> callTopBitcoinApi() async {
//    setState(() {
//      isLoading = true;
//    });
    var uri =
    // '$URL/Bitcoin/resources/getBitcoinHistoryLists?size=0';
        'http://45.34.15.25:8080/Bitcoin/resources/getBitcoinHistoryLists?size=0';

    //  print(uri);
    var response = await get(Uri.parse(uri));
    //   print(response.body);
    final data = json.decode(response.body) as Map;
    //  print(data);
    if (mounted) {
      if (data['error'] == false) {
        setState(() {
          topCoinList.addAll(data['data']
              .map<TopCoinData>((json) => TopCoinData.fromJson(json))
              .toList());
          isLoading = false;
          // _size = _size + data['data'].length;
        });
      } else {
        //  _ackAlert(context);
        setState(() {});
      }
    }
    callGainerLooserBitcoinApi();
  }

  Future<void> callGainerLooserBitcoinApi() async {
//    setState(() {
//      isLoading = true;
//    });
    var uri =
    // '$URL/Bitcoin/resources/getBitcoinListLoser?size=0';
        'http://45.34.15.25:8080/Bitcoin/resources/getBitcoinListLoser?size=0';

    //  print(uri);
    var response = await get(Uri.parse(uri));
    //   print(response.body);
    final data = json.decode(response.body) as Map;
    //  print(data);
    if (mounted) {
      if (data['error'] == false) {
        setState(() {
          gainerLooserCoinList.addAll(data['data']
              .map<Bitcoin>((json) => Bitcoin.fromJson(json))
              .toList());
          isLoading = false;
          // _size = _size + data['data'].length;
        }
        );
      }

      else {
        //  _ackAlert(context);
        setState(() {});
      }
    }
    if (data['error'] == false) {
      setState(() {
        bitcoinList = data['data'].map<Bitcoin>((json) => Bitcoin.fromJson(json)).toList();
        double count = 0;
        diffRate = double.parse(data['diffRate']);
        if (diffRate < 0) result = data['diffRate'].replaceAll("-", "");
        else result = data['diffRate'];
        currencyData = [];
        bitcoinList.forEach((element) {
          currencyData.add(chartData(count, element.rate!));
          name = element.name!;
          String step2 = element.rate!.toStringAsFixed(2);
          double step3 = double.parse(step2);
          coin = step3;
          count = count + 1;
        });
        //  print(currencyData.length);
      });
    }

    }




  Future<void> callCurrencyDetails(name) async {
    _saveProfileData(name);
  }

  _saveProfileData(String name) async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences!.setString("currencyName", name);
      sharedPreferences!.setInt("index", 4);
      sharedPreferences!.setString("title", "trends");
      sharedPreferences!.commit();
    });

    Navigator.pushNamedAndRemoveUntil(context, 'trendPage', (r) => false);
  }
}

class chartData {

  final double date;
  final double rate;

  chartData(this.date, this.rate);
}
