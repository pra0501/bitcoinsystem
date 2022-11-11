// ignore_for_file: deprecated_member_use, import_of_legacy_library_into_null_safe

import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'portfolio_page.dart';
import 'models/Bitcoin.dart';
import 'models/PortfolioBitcoin.dart';
import 'dashboard_helper.dart';

class TrendPage extends StatefulWidget {
  const TrendPage({Key? key}) : super(key: key);

  @override
  _TrendPageState createState() => _TrendPageState();
}

class _TrendPageState extends State<TrendPage> {
  int buttonType = 3;
  String name = "";
  double coin = 0;
  String result = '';
  SharedPreferences? sharedPreferences;
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  String? currencyNameForImage;
  String _type = "Week";
  List<chartData> currencyData = [];
  List<Bitcoin> bitcoinList = [];
  double totalValuesOfPortfolio = 0.0;
  double diffRate = 0;
  final _formKey2 = GlobalKey<FormState>();
  String? URL;

  TextEditingController? coinCountTextEditingController;
  TextEditingController? coinCountEditTextEditingController;
  final dbHelper = DatabaseHelper.instance;
  List<PortfolioBitcoin> items = [];
  TextEditingController _searchController = new TextEditingController();

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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var analytics = FirebaseAnalytics();
      analytics.logEvent(name: 'open_trends');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(image: DecorationImage(
                  image: AssetImage("assets/image/trend_container.png"),
                  fit: BoxFit.cover,
                ),),
                height: 200,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20,),
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
                            width:150,
                          ),
                          Text('$name',
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                        height: 20,
                    ),
                    Text('\$$coin', style: const TextStyle(fontSize: 25,fontWeight:FontWeight.bold,color:Colors.black)),
                    const SizedBox(
                      height: 20,
                      width: 100,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        children: <Widget>[
                          Text(diffRate < 0 ? '-' : "+", textAlign: TextAlign.center,style: TextStyle(fontSize: 20, color: diffRate < 0 ? Colors.red : Colors.green)),
                          Icon(Icons.attach_money, size: 20, color: diffRate < 0 ? Colors.red : Colors.green),
                          Text('$result', textAlign: TextAlign.center,style: TextStyle(fontSize: 20, color: diffRate < 0 ? Colors.red : Colors.green)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Container(
                  child: ListView(
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/image/Rectangle 2.png"), fit: BoxFit.fill,)),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top:5.0),
                                child: Row(
                                  children: <Widget>[
                                    Center(
                                      child: Container(
                                          width: MediaQuery.of(context).size.width / 1.01,
                                          height: MediaQuery.of(context).size.height / 2.0,
                                          child: SfCartesianChart(
                                            plotAreaBorderWidth: 0,
                                            enableAxisAnimation: true,
                                            enableSideBySideSeriesPlacement: true,
                                            series:<ChartSeries>[
                                              SplineSeries<chartData, double>(
                                                dataSource: currencyData,
                                                xValueMapper: (chartData data, _) => data.date,
                                                yValueMapper: (chartData data, _) => data.rate,
                                                color: Colors.blue,
                                                dataLabelSettings: const DataLabelSettings(isVisible: true, borderColor: Colors.blue),
                                                markerSettings: const MarkerSettings(isVisible: true),
                                              )
                                            ],
                                            primaryXAxis: NumericAxis(isVisible: false,),
                                            primaryYAxis: NumericAxis(isVisible: false,),
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[

                                  ButtonTheme(
                                    minWidth: 50.0, height: 40.0,
                                    child: ElevatedButton(
                                      child: const Text("7 Days" , style: TextStyle(fontSize: 15),),
                                      style: ButtonStyle(
                                          foregroundColor: MaterialStateProperty.all<Color>(buttonType == 3 ? Colors.white:const Color(0xff96a5ff)),
                                          backgroundColor: MaterialStateProperty.all<Color>(buttonType == 3 ? const Color(0xff96a5ff) : Colors.white,),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                // side: BorderSide(color: Color(0xfff4f727))
                                              )
                                          )
                                      ),
                                      // textColor: buttonType == 3 ? Color(0xff96a5ff) : Colors.white,
                                      // shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0),),
                                      // color: buttonType == 3 ? Colors.white : Color(0xff96a5ff),
                                      onPressed: () {
                                        setState(() {
                                          buttonType = 3;
                                          _type = "Week";
                                          callBitcoinApi();
                                        });
                                      },
                                    ),
                                  ),
                                  ButtonTheme(
                                    minWidth: 50.0, height: 40.0,
                                    child: ElevatedButton(
                                      child: const Text('30 Days', style: TextStyle(fontSize: 15),),
                                      style: ButtonStyle(
                                          foregroundColor: MaterialStateProperty.all<Color>(buttonType == 4 ? Colors.white:const Color(0xff96a5ff)),
                                          backgroundColor: MaterialStateProperty.all<Color>(buttonType == 4 ? const Color(0xff96a5ff) : Colors.white,),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                // side: BorderSide(color: Color(0xfff4f727))
                                              )
                                          )
                                      ),
                                      // textColor: buttonType == 4 ? Color(0xff96a5ff) : Colors.white,
                                      // shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0),),
                                      // color: buttonType == 4 ? Colors.white : Color(0xff96a5ff),
                                      onPressed: () {
                                        setState(() {
                                          buttonType = 4;
                                          _type = "Month";
                                          callBitcoinApi();
                                        });
                                      },
                                    ),
                                  ),
                                  ButtonTheme(
                                    minWidth: 50.0, height: 40.0,
                                    child: ElevatedButton(
                                      child: const Text('365 Days', style: TextStyle(fontSize: 15),),
                                      style: ButtonStyle(
                                          foregroundColor: MaterialStateProperty.all<Color>(buttonType == 5 ? Colors.white:const Color(0xff96a5ff)),
                                          backgroundColor: MaterialStateProperty.all<Color>(buttonType == 5 ? const Color(0xff96a5ff) : Colors.white,),
                                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                // side: BorderSide(color: Color(0xfff4f727))
                                              )
                                          )
                                      ),

                                      // textColor: buttonType == 5 ? Color(0xff96a5ff) : Colors.white,
                                      // shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0),),
                                      // color: buttonType == 5 ? Colors.white : Color(0xff96a5ff),
                                      onPressed: () {
                                        setState(() {
                                          buttonType = 5;
                                          _type = "Year";
                                          callBitcoinApi();
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                            ],
                          )
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width:400,
                child: ElevatedButton(
                  onPressed: (){
                    showPortfolioDialog(name,coin);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xfffcc167),

                  ),
                  child: const Text("Add Coins",
                  style: TextStyle(fontSize: 15,color: Colors.black),),
                ),
              ),
            ],
          ),
        )
    );
  }

  Future<void> callBitcoinApi() async {
    final SharedPreferences prefs = await _sprefs;
    var currencyName = prefs.getString("currencyName") ?? 'BTC';
    currencyNameForImage = currencyName;
    // var uri = '$URL/Bitcoin/resources/getBitcoinGraph?type=$_type&name=$currencyName';
    var uri = 'http://45.34.15.25:8080/Bitcoin/resources/getBitcoinGraph?type=$_type&name=$currencyName';
    print(uri);
    var response = await get(Uri.parse(uri));
    //  print(response.body);
    final data = json.decode(response.body) as Map;
    //print(data);
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
    } else {
      //  _ackAlert(context);
    }
  }
  Future<void> showPortfolioDialog(String name, double coin) async {
    showCupertinoModalPopup(
        context: context,
        builder: (ctxt) => Container(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(

            body: Container(
              child: ListView(
                //mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 400,
                    decoration: const BoxDecoration(color: Colors.black),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              InkWell(
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                                onTap: (){
                                  //action code when clicked
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const TrendPage()),
                                  );
                                },
                              ),
                              const SizedBox(
                                width: 140,
                              ),
                              const Text("Add Coins",
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                                textAlign: TextAlign.start,
                              ),

                            ],
                          ),
                        ),
                        Row(
                            children:<Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: FadeInImage(
                                          height: 100,
                                          placeholder: const AssetImage('assetsEvo/imagesEvo/cob.png'),
                                          image: NetworkImage(
                                            // "$URL/Bitcoin/resources/icons/${bitcoin.name!.toLowerCase()}.png"),
                                              "http://45.34.15.25:8080/Bitcoin/resources/icons/${name!.toLowerCase()}.png"),
                                        ),
                                      ),
                                      const SizedBox(
                                        height:10,
                                      ),
                                    ]
                                ),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              Column(
                                children: [
                                  Text(name,
                                    style: const TextStyle(fontSize: 15, color: Colors.grey),),
                                  const SizedBox(
                                    height:10,
                                  ),
                                  Text('\$$coin', style: const TextStyle(fontSize: 25,fontWeight:FontWeight.bold,color:Colors.white)),
                                ],
                              ),


                            ]
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top:50),
                          child: Text("Enter Number of Coins",textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Form(
                            key: _formKey2,
                            child: TextFormField(
                              controller: coinCountTextEditingController,
                              style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color:Colors.white),textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.white,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (val) {
                                if (coinCountTextEditingController!.text == "" || int.parse(coinCountTextEditingController!.value.text) <= 0) {
                                  return "At least 1 coin should be added";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 200,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      SizedBox(
                        width:400,
                        child: TextButton(
                          style: ButtonStyle(
                            // foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xfffcc167)),
                          ),
                          // height: 60,
                          // shape: CircleBorder(
                          //     side: BorderSide.none
                          // ),
                          child: const Text("Add",
                            textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
                            fontSize: 15),),
                          // color: Colors.blueAccent,
                          onPressed: (){
                            _addSaveCoinsToLocalStorage(name,coin);
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  _addSaveCoinsToLocalStorage(String name,double rate) async {
    if (_formKey2.currentState!.validate()) {
      if (items.length > 0) {
        PortfolioBitcoin? bitcoinLocal =
        items.firstWhereOrNull(
                (element) => element.name == name);

        if (bitcoinLocal != null) {
          Map<String, dynamic> row = {
            DatabaseHelper.columnName: name,
            DatabaseHelper.columnRateDuringAdding: rate,
            DatabaseHelper.columnCoinsQuantity:
            double.parse(coinCountTextEditingController!.value.text) +
                bitcoinLocal.numberOfCoins,
            DatabaseHelper.columnTotalValue:
            double.parse(coinCountTextEditingController!.value.text) *
                (rate!) +
                bitcoinLocal.totalValue,
          };
          final id = await dbHelper.update(row);
          print('inserted row id: $id');
        } else {
          Map<String, dynamic> row = {
            DatabaseHelper.columnName: name,
            DatabaseHelper.columnRateDuringAdding: rate,
            DatabaseHelper.columnCoinsQuantity:
            double.parse(coinCountTextEditingController!.value.text),
            DatabaseHelper.columnTotalValue:
            double.parse(coinCountTextEditingController!.value.text) *
                (rate!),
          };
          final id = await dbHelper.insert(row);
          print('inserted row id: $id');
        }
      } else {
        Map<String, dynamic> row = {
          DatabaseHelper.columnName: name,
          DatabaseHelper.columnRateDuringAdding: rate,
          DatabaseHelper.columnCoinsQuantity:
          double.parse(coinCountTextEditingController!.text),
          DatabaseHelper.columnTotalValue:
          double.parse(coinCountTextEditingController!.value.text) *
              (rate!),
        };
        final id = await dbHelper.insert(row);
        print('inserted row id: $id');
      }

      sharedPreferences = await SharedPreferences.getInstance();
      setState(() {
        sharedPreferences!.setString("currencyName", name!);
        sharedPreferences!.setInt("index", 3);
        sharedPreferences!.setString("title", "portfolio");
        sharedPreferences!.commit();
      });
      Navigator.pushNamedAndRemoveUntil(context, '/homePage', (r) => false);
    } else {}
  }

}

// class LinearSales {
//   final double date;
//   final double rate;
//
//   LinearSales(this.date, this.rate);
// }
class chartData {

  final double date;
  final double rate;

  chartData(this.date, this.rate);
}
