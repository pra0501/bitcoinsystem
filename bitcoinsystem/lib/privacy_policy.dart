import 'package:flutter/material.dart';
//import 'localization/app_localizations.dart';
import 'portfolio_page.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  ScrollController? _controllerList;

  @override
  void initState() {
    _controllerList = ScrollController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          controller: _controllerList,
          children: <Widget>[
            Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          const SizedBox(
                            height: 5,
                          ),
                          Row(
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
                                width: 60,
                              ),
                              const Text('PRIVACY POLICY',
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          const Text("BITCOIN EVOLUTION built the BITCOIN EVOLUTION app as a Free app. This SERVICE is provided by BITCOIN EVOLUTION at no cost and is intended for use as is.",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // Text(AppLocalizations.of(context).translate('pp2'),
                          //   style: const TextStyle(fontSize: 16, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp3'),
                          //   style: const TextStyle(fontSize: 16, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp4'),
                          //   style: const TextStyle(fontSize: 16, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp5'),
                          //   style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp6'),
                          //   style: const TextStyle(fontSize: 16, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp7'),
                          //   style: const TextStyle(fontSize: 16, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp8'),
                          //   style: const TextStyle(fontSize: 16, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp9'),
                          //   style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp10'),
                          //   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp11'),
                          //   style: const TextStyle(fontSize: 16, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp12'),
                          //   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp13'),
                          //   style: const TextStyle(fontSize: 16, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp14'),
                          //   style: const TextStyle(fontSize: 16, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp15'),
                          //   style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp16'),
                          //   style: const TextStyle(fontSize: 16, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp17'),
                          //   style: const TextStyle(fontSize: 16, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp18'),
                          //   style: const TextStyle(fontSize: 16, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp19'),
                          //   style: const TextStyle(fontSize: 16, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp20'),
                          //   style: const TextStyle(fontSize: 16, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp21'),
                          //   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp22'),
                          //   style: const TextStyle(fontSize: 16, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp23'),
                          //   style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp24'),
                          //   style: const TextStyle(fontSize: 16, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp25'),
                          //   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp26'),
                          //   style: const TextStyle(fontSize: 16, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp27'),
                          //   style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp28'),
                          //   style: const TextStyle(fontSize: 16, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp29'),
                          //   style: const TextStyle(fontSize: 16, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp30'),
                          //   style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // Text(AppLocalizations.of(context).translate('pp31'),
                          //   style: const TextStyle(fontSize: 16, color: Colors.black),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),

                        ],
                      ),
                    ),
                  ],
                )
            )
          ],
        )
    );
  }
}
