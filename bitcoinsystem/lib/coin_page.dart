// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_helper.dart';
import 'portfolio_page.dart';
import 'models/Bitcoin.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'models/PortfolioBitcoin.dart';

class CoinsPage extends StatefulWidget{
  const CoinsPage({super.key});

  @override
  State<CoinsPage> createState() =>  _CoinsPageState();

}

class _CoinsPageState extends State<CoinsPage>{
  List<Bitcoin> bitcoinList = [];
  List<Bitcoin> _searchResult = [];
  TextEditingController _searchController = new TextEditingController();
  bool isLoading = false;
  SharedPreferences? sharedPreferences;
  num size = 0;
  double totalValuesOfPortfolio = 0.0;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  bool addButton = false;
  String buttonValue = "BTC";

  TextEditingController? coinCountTextEditingController;
  TextEditingController? coinCountEditTextEditingController;
  final dbHelper = DatabaseHelper.instance;
  List<PortfolioBitcoin> items = [];



  @override
  void initState() {
    // TODO: implement initState
    callBitcoinApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: ListView(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(15.0),
          //   child: Container(
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         Card(
          //           elevation: 1,
          //           color: Colors.white,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(15),
          //           ),
          //           child: Container(
          //             width: MediaQuery.of(context).size.width/1.12,
          //             child: Padding(
          //               padding: const EdgeInsets.all(4.0),
          //               child: TypeAheadField(
          //                 textFieldConfiguration: TextFieldConfiguration(
          //                     autofocus: false,
          //                     keyboardType: TextInputType.text,
          //                     controller: _searchController,
          //                     onChanged: (val) => onSearchTextChanged(val),
          //                     style: const TextStyle(fontSize: 20, color: Colors.white),
          //                     decoration: const InputDecoration(
          //                       focusedBorder: InputBorder.none,
          //                       enabledBorder: InputBorder.none,
          //                       suffixIcon: IconButton(
          //                         icon: Icon(
          //                           Icons.search,
          //                           color: Color(0xff8e9bae),
          //                           size: 35,
          //                         ),
          //                         onPressed: null,
          //                       ),
          //                       hintText: "Search",
          //                       hintStyle: TextStyle(color: Color(0xff6e7a8d), fontSize: 16),
          //                       fillColor: Color(0xff6e7a8d),
          //                     )),
          //                 suggestionsCallback: (pattern) async {
          //                   return await null; //_buildListView(pattern);
          //                 },
          //                 itemBuilder: (context, dynamic suggestion) {
          //                   return ListTile(
          //                     leading: const Icon(Icons.search),
          //                     title: Text(suggestion!.name),
          //                   );
          //                 },
          //                 onSuggestionSelected: (suggestion) {
          //                 },
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
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
                const Text("Coins",
                  style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                height: MediaQuery.of(context).size.height/1.3,
                child: bitcoinList.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : _searchResult.isNotEmpty ||
                    _searchController.text.isNotEmpty
                    ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _searchResult.length,
                    itemBuilder: (BuildContext context, int i) {
                      if(addButton == true && _searchResult[i].name == buttonValue) {
                        return InkWell(
                          onTap: () {
                            callCurrencyDetails(_searchResult[i].name);
                          },
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              padding: const EdgeInsets.all(10),
                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left:5.0),
                                              child: FadeInImage(
                                                width: 50,
                                                height: 50,
                                                placeholder: const AssetImage('images/cob.png'),
                                                image: NetworkImage("http://45.34.15.25:8080/Bitcoin/resources/icons/${_searchResult[i].name!.toLowerCase()}.png"),
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(left:10.0),
                                                child:Text('${_searchResult[i].name}',
                                                  style: const TextStyle(fontSize: 20,fontWeight:FontWeight.bold,color:Colors.black),
                                                  textAlign: TextAlign.left,
                                                )
                                            ),
                                          ]
                                      ),

                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:65),
                                    child: Text('\$ ${double.parse(_searchResult[i].rate!.toStringAsFixed(2))}',
                                      style: const TextStyle(fontSize: 25,color:Colors.black),textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          GestureDetector(
                                            child: Container(
                                              width:MediaQuery.of(context).size.width/1.7,
                                              height: 80,
                                              child: charts.LineChart(
                                                _createSampleData(_searchResult[i].historyRate, double.parse(_searchResult[i].diffRate!)),
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
                                      Row(
                                          crossAxisAlignment:CrossAxisAlignment.end,
                                          mainAxisAlignment:MainAxisAlignment.end,
                                          children:[
                                            double.parse(_searchResult[i].diffRate!) < 0
                                                ? const Icon(Icons.arrow_downward, color: Colors.red, size: 20,)
                                                : const Icon(Icons.arrow_upward, color: Colors.green, size: 20,),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Text(double.parse(_searchResult[i].diffRate!) < 0
                                                ? "${double.parse(_searchResult[i].diffRate!.replaceAll('-', "")).toStringAsFixed(2)} %"
                                                : "${double.parse(_searchResult[i].diffRate!).toStringAsFixed(2)} %",
                                                style: TextStyle(fontSize: 18,
                                                    color: double.parse(_searchResult[i].diffRate!) < 0
                                                        ? Colors.red
                                                        : Colors.green)
                                            ),
                                          ]
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            showBitcoin(_searchResult[i]);
                          },
                          child: Container(
                            decoration: const BoxDecoration(color: Color(0xff1a2537)),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5.0),
                                        child: FadeInImage(
                                          width: 40,
                                          height: 40,
                                          placeholder: const AssetImage('images/cob.png'),
                                          image: NetworkImage(
                                              "http://45.34.15.25:8080/Bitcoin/resources/icons/${_searchResult[i]
                                                  .name!.toLowerCase()}.png"),
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child: Column(
                                            children: [
                                              Text('${_searchResult[i].name}',
                                                style: const TextStyle(fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                                textAlign: TextAlign.left,
                                              ),
                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 60.0),
                                        child: Text('\$ ${double.parse(
                                            _searchResult[i].rate!.toStringAsFixed(2))}',
                                            style: const TextStyle(
                                                fontSize: 20, color: Colors.black)
                                        ),
                                      ),
                                      Text(double.parse(_searchResult[i].diffRate!) < 0
                                          ? "${double.parse(
                                          _searchResult[i].diffRate!.replaceAll('-', ""))
                                          .toStringAsFixed(2)} %"
                                          : "${double.parse(_searchResult[i].diffRate!)
                                          .toStringAsFixed(2)} %",
                                          style: TextStyle(fontSize: 18,
                                              color: double.parse(_searchResult[i].diffRate!) < 0
                                                  ? Colors.red : Colors.green)
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        );
                      }
                    })
                    : ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: bitcoinList.length,
                    itemBuilder: (BuildContext context, int i) {
                      if(addButton == true && bitcoinList[i].name == buttonValue) {
                        return InkWell(
                          onTap: () {
                            callCurrencyDetails(bitcoinList[i].name);
                          },
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              padding: const EdgeInsets.all(10),
                              child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left:5.0),
                                              child: FadeInImage(
                                                width: 50,
                                                height: 50,
                                                placeholder: const AssetImage('images/cob.png'),
                                                image: NetworkImage("http://45.34.15.25:8080/Bitcoin/resources/icons/${bitcoinList[i].name!.toLowerCase()}.png"),
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.only(left:10.0),
                                                child:Text('${bitcoinList[i].name}',
                                                  style: const TextStyle(fontSize: 20,fontWeight:FontWeight.bold,color:Colors.black),
                                                  textAlign: TextAlign.left,
                                                )
                                            ),
                                          ]
                                      ),

                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:65),
                                    child: Text('\$ ${double.parse(bitcoinList[i].rate!.toStringAsFixed(2))}',
                                      style: const TextStyle(fontSize: 25,color:Colors.black),textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          GestureDetector(
                                            child: Container(
                                              width:MediaQuery.of(context).size.width/1.7,
                                              height: 80,
                                              child: charts.LineChart(
                                                _createSampleData(bitcoinList[i].historyRate, double.parse(bitcoinList[i].diffRate!)),
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
                                      Row(
                                          crossAxisAlignment:CrossAxisAlignment.end,
                                          mainAxisAlignment:MainAxisAlignment.end,
                                          children:[
                                            double.parse(bitcoinList[i].diffRate!) < 0
                                                ? const Icon(Icons.arrow_downward, color: Colors.red, size: 20,)
                                                : const Icon(Icons.arrow_upward, color: Colors.green, size: 20,),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Text(double.parse(bitcoinList[i].diffRate!) < 0
                                                ? "${double.parse(bitcoinList[i].diffRate!.replaceAll('-', "")).toStringAsFixed(2)} %"
                                                : "${double.parse(bitcoinList[i].diffRate!).toStringAsFixed(2)} %",
                                                style: TextStyle(fontSize: 18,
                                                    color: double.parse(bitcoinList[i].diffRate!) < 0
                                                        ? Colors.red
                                                        : Colors.green)
                                            ),
                                          ]
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }else {
                        return GestureDetector(
                          onTap: () {
                            showBitcoin(bitcoinList[i]);
                          },
                          child: Container(
                            decoration: const BoxDecoration(color: Colors.white),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0),
                                        child: FadeInImage(
                                          width: 40,
                                          height: 40,
                                          placeholder: const AssetImage(
                                              'images/cob.png'),
                                          image: NetworkImage(
                                              "http://45.34.15.25:8080/Bitcoin/resources/icons/${bitcoinList[i]
                                                  .name!.toLowerCase()}.png"),
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0),
                                          child: Column(
                                            children: [
                                              Text('${bitcoinList[i].name}',
                                                style: const TextStyle(fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                                textAlign: TextAlign.left,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(double.parse(bitcoinList[i].diffRate!) < 0 ? '-' : '+',
                                                      style: TextStyle(fontSize: 12, color: double.parse(bitcoinList[i].diffRate!) < 0 ? Colors.red : Colors.green)),
                                                  Icon(Icons.attach_money, size: 12, color: double.parse(bitcoinList[i].diffRate!) < 0 ? Colors.red : Colors.green),
                                                  Text(double.parse(bitcoinList[i].diffRate!) < 0 ? double.parse(bitcoinList[i].diffRate!.replaceAll('-', "")).toStringAsFixed(2)
                                                      : double.parse(bitcoinList[i].diffRate!).toStringAsFixed(2),
                                                      style: TextStyle(fontSize: 12, color: double.parse(bitcoinList[i].diffRate!) < 0 ? Colors.red : Colors.green)),
                                                ],
                                              ),
                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 60.0),
                                        child: Text('\$ ${double.parse(
                                            bitcoinList[i].rate!
                                                .toStringAsFixed(2))}',
                                            style: const TextStyle(fontSize: 20,
                                                color: Colors.black)
                                        ),
                                      ),

                                    ],
                                  ),
                                ]),
                          ),
                        );
                      }
                    })
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
    var uri = 'http://45.34.15.25:8080/Bitcoin/resources/getBitcoinList?size=$size';
    var response = await get(Uri.parse(uri));
    final data = json.decode(response.body) as Map;
    if (data['error'] == false) {
      setState(() {
        bitcoinList.addAll(data['data']
            .map<Bitcoin>((json) => Bitcoin.fromJson(json))
            .toList());
        isLoading = false;
        size = size + data['data'].length;
      });
    } else {
      setState(() {});
    }
  }

  showBitcoin(Bitcoin bitcoin) async{
    print("bitcoin value ");
    print(bitcoin.name);
    addButton = true;
    buttonValue = bitcoin.name!;
    callBitcoinApi();
  }

  _saveProfileData(String name) async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences!.setString("currencyName", name);
      //sharedPreferences!.setInt("index", 4);
      sharedPreferences!.setString("title", "trends");
      sharedPreferences!.commit();
    });

    Navigator.pushNamedAndRemoveUntil(context, '/trendPage', (r) => false);
  }

  Future<void> callCurrencyDetails(name) async {
    _saveProfileData(name);
  }

  Future<void> showPortfolioDialog(Bitcoin bitcoin) async {
    showCupertinoModalPopup(
        context: context,
        builder: (ctxt) => Container(
          height: MediaQuery.of(context).size.height,
          child: Scaffold(
            backgroundColor: const Color(0xff1a2537),
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: Colors.black),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 25,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              elevation: 0,
              centerTitle: true,
              backgroundColor: const Color(0xff1a2537),
              title: const Text("Add Coins",
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            body: Container(
              child: ListView(
                // mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(width: 1)
                      ),
                      child: Container(
                        decoration: BoxDecoration(color: const Color(0xff1a2537),
                            borderRadius: BorderRadius.circular(15)),
                        padding: const EdgeInsets.all(10),
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Row(
                              children: [
                                Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left:5.0),
                                        child: FadeInImage(
                                          width: 50,
                                          height: 50,
                                          placeholder: const AssetImage('images/cob.png'),
                                          image: NetworkImage("http://45.34.15.25:8080/Bitcoin/resources/icons/${bitcoin.name!.toLowerCase()}.png"),
                                        ),
                                      ),
                                      Padding(
                                          padding:
                                          const EdgeInsets.only(left:10.0),
                                          child:Text('${bitcoin.name}',
                                            style: const TextStyle(fontSize: 20,fontWeight:FontWeight.bold,color:Color(0xff4c586b)),
                                            textAlign: TextAlign.left,
                                          )
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left:60.0),
                                        child: Text('USD ${double.parse(bitcoin.rate!.toStringAsFixed(2))}',
                                            style: const TextStyle(fontSize: 25,color:Color(0xff8c929b))
                                        ),
                                      ),
                                    ]),
                              ],
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Container(
                                        width:MediaQuery.of(context).size.width/2.5,
                                        height: 80,
                                        child: charts.LineChart(
                                          _createSampleData(bitcoin.historyRate, double.parse(bitcoin.diffRate!)),
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
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 90),
                                Row(
                                    crossAxisAlignment:CrossAxisAlignment.end,
                                    mainAxisAlignment:MainAxisAlignment.end,
                                    children:[
                                      double.parse(bitcoin.diffRate!) < 0
                                          ? const Icon(Icons.arrow_downward, color: Colors.red, size: 20,)
                                          : const Icon(Icons.arrow_upward, color: Colors.green, size: 20,),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Text(double.parse(bitcoin.diffRate!) < 0
                                          ? "${double.parse(bitcoin.diffRate!.replaceAll('-', "")).toStringAsFixed(2)} %"
                                          : "${double.parse(bitcoin.diffRate!).toStringAsFixed(2)} %",
                                          style: TextStyle(fontSize: 18,
                                              color: double.parse(bitcoin.diffRate!) < 0
                                                  ? Colors.red : Colors.green)
                                      ),
                                      const SizedBox(
                                          height: 5,
                                          width:15
                                      ),
                                    ]
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(width: 1)
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: const Color(0xff1a2537),
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Add Coins", textAlign: TextAlign.left,
                                        style: TextStyle(fontSize: 22, color: Colors.white,fontWeight: FontWeight.w400)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child:Row(
                                    children: [
                                      FadeInImage(
                                        width: 30,
                                        height: 30,
                                        placeholder: const AssetImage('images/cob.png'),
                                        image: NetworkImage("http://45.34.15.25:8080/Bitcoin/resources/icons/${bitcoin.name!.toLowerCase()}.png"),
                                      ),
                                      const SizedBox(width:10),
                                      Text("1 "+bitcoin.name!, style: const TextStyle(fontSize: 18, color: Colors.white,fontStyle: FontStyle.italic)),
                                      const SizedBox(width:10),
                                      const Icon(Icons.arrow_forward, color: Colors.white, size: 25,),
                                      const SizedBox(width:10),
                                      Text(' ${double.parse(bitcoin.rate!.toStringAsFixed(2))} ',
                                          style: const TextStyle(fontSize: 22, color: Colors.white)),
                                      const Text('  USD',
                                          style: TextStyle(fontSize: 18, color: Colors.white))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 50),
                              // Padding(
                              //   padding: EdgeInsets.all(10),
                              //   child:
                              // ),
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left:15, top:10),
                                  child: Text("Add", textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 22, color: Colors.white,fontWeight: FontWeight.w400)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Card(
                                  color: const Color(0xff10192d),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                    child: Form(
                                      key: _formKey2,
                                      child: TextFormField(
                                        controller: coinCountTextEditingController,
                                        style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.white),
                                        keyboardType: TextInputType.number,
                                        keyboardAppearance: Brightness.light,
                                        cursorColor: Colors.black,
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

                                ),
                              ),
                              const SizedBox(height: 90,),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Container(
                                  width: double.infinity,
                                  child: TextButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent,),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              // side: BorderSide(color: Color(0xfff4f727))
                                            )
                                        )
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Text("Add", style: TextStyle(color: Colors.white, fontSize: 22),),
                                    ),
                                    onPressed: () => _addSaveCoinsToLocalStorage(bitcoin),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20,)
                            ],
                          ),
                        )
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  _addSaveCoinsToLocalStorage(Bitcoin bitcoin) async {
    if (_formKey2.currentState!.validate()) {
      if (items.isNotEmpty) {
        PortfolioBitcoin? bitcoinLocal = items.firstWhereOrNull((element) => element.name == bitcoin.name);
        if (bitcoinLocal != null) {
          Map<String, dynamic> row = {
            DatabaseHelper.columnName: bitcoin.name,
            DatabaseHelper.columnRateDuringAdding: bitcoin.rate,
            DatabaseHelper.columnCoinsQuantity:
            double.parse(coinCountTextEditingController!.value.text) + bitcoinLocal.numberOfCoins!,
            DatabaseHelper.columnTotalValue:
            double.parse(coinCountTextEditingController!.value.text) * (bitcoin.rate!) + bitcoinLocal.totalValue!,
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
            double.parse(coinCountTextEditingController!.value.text) * (bitcoin.rate!),
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
          double.parse(coinCountTextEditingController!.value.text) * (bitcoin.rate!),
        };
        final id = await dbHelper.insert(row);
        print('inserted row id: $id');
      }

      sharedPreferences = await SharedPreferences.getInstance();
      setState(() {
        sharedPreferences!.setString("currencyName", bitcoin.name!);
        sharedPreferences!.setInt("index", 2);
        sharedPreferences!.setString("title", 'COINS');
        sharedPreferences!.commit();
      });
      Navigator.pushNamedAndRemoveUntil(context, '/homePage', (r) => false);
    } else {}
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    text = text.toLowerCase();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    bitcoinList.forEach((userDetail) {
      if (userDetail.name!.toLowerCase().contains(text)) {
        _searchResult.add(userDetail);
      }
    });

    setState(() {});
  }
}

class LinearSales {
  final int count;
  final double rate;

  LinearSales(this.count, this.rate);
}

