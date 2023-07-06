

// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'dart:convert';

import 'package:bitcoinproapp/Ui/PortfolioScreen.dart';
import 'package:bitcoinproapp/Ui/TopCoinsScreen.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../Models/Bitcoin.dart';
import '../Util/AppLanguage.dart';
import '../Util/LanguageData.dart';
import '../Util/app_decoration.dart';
import '../Util/app_localizations.dart';
import '../Util/app_style.dart';
import '../Util/color_constant.dart';
import '../Util/color_util.dart';
import '../Util/custom_image_view.dart';
import '../Util/font_util.dart';
import '../Util/image_constant.dart';
import '../Util/size_utils.dart';
import '../Util/text_widgets.dart';
import 'CoinsScreen.dart';
import 'TrendScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();

}

class HomeScreenState extends State<HomeScreen> {

  String ?ApiUrl;
  String ?iFrameUrl;
  bool ?disableIframe;
  late WebViewController webViewController;
  List<Bitcoin> bitcoinList = [];
  bool isLoading = false;
  Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
  String? languageCodeSaved;
  final controller = PageController(viewportFraction: 0.8, keepPage: true);


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

  Future<void> getSharedPrefData() async {
    final SharedPreferences prefs = await _sprefs;
    setState(() {
      languageCodeSaved = prefs.getString('language_code') ?? "en";
    });
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    getCoinsList();
    getSharedPrefData();
    // fetchRemoteValue();
    super.initState();
  }

  fetchRemoteValue() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ));
      await remoteConfig.fetchAndActivate();
      iFrameUrl = remoteConfig.getString('bitcoin_pro_iframe_url').trim();
      disableIframe = remoteConfig.getBool('bitcoin_pro_disable_Iframe');
      ApiUrl = remoteConfig.getString('bitcoin_pro_tomcat_url').trim();

      print(ApiUrl);
      setState(() {});
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be used');
    }
    getCoinsList();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(iFrameUrl!)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(iFrameUrl!));
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
        backgroundColor: ColorConstant.gray50,
        body: SafeArea(
          child: isLoading
              ?const Center(child: CircularProgressIndicator())
              :Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: getVerticalSize(
                          disableIframe== true?2000.00:1520.00,
                        ),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [

                            Padding(
                              padding: getPadding(
                                top: 180,
                              ),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  height: 400,
                                  child: Image.asset('assets/images/img_home_image_03.png'),

                                ),
                              ),
                            ),

                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 400,
                                child: Image.asset('assets/images/img_home_image_02.png'),

                              ),
                            ),

                            Align(
                              child: Padding(
                                padding: getPadding(
                                  left: 24,
                                  right: 24,
                                  bottom: 60,
                                  top: 300,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [

                                    Container(
                                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                                      child: Image.asset('assets/images/bitcoin_pro_home_icon_top.png'),
                                    ),

                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: getTextWidgetMaxLines(
                                          AppLocalizations.of(context)!.translate('home_string01')!,
                                          44,
                                          getColorFromHex('#171717'),
                                          FontWeight.w700, TextAlign.start, FontUtil.ROBOTOBOLD, 1),
                                    ),

                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: getTextWidgetMaxLines(
                                          AppLocalizations.of(context)!.translate('home_string02')!,
                                          44,
                                          getColorFromHex('#495AB2'),
                                          FontWeight.w700, TextAlign.start, FontUtil.ROBOTOBOLD, 1),
                                    ),

                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: getTextWidgetMaxLines(
                                          AppLocalizations.of(context)!.translate('home_string03')!,
                                          44,
                                          getColorFromHex('#171717'),
                                          FontWeight.w700, TextAlign.start, FontUtil.ROBOTOBOLD, 2),
                                    ),

                                    Container(
                                      alignment: Alignment.topLeft,
                                      margin: getMargin(
                                        top: 70,
                                      ),
                                      child: getTextWidgetMaxLinesVerSpaces(
                                          AppLocalizations.of(context)!.translate('home_string04')!,
                                          18,
                                          getColorFromHex('#171717'),
                                          FontWeight.w400, TextAlign.start, FontUtil.ROBOTOREGULAR, 6, 1.8),
                                    ),


                                    // Container(
                                    //   width: getHorizontalSize(
                                    //     189.00,
                                    //   ),
                                    //   margin: getMargin(
                                    //     top: 100,
                                    //   ),
                                    //   padding: getPadding(
                                    //     top: 15,
                                    //     bottom: 15,
                                    //   ),
                                    //   decoration: AppDecoration
                                    //       .txtFillIndigo500
                                    //       .copyWith(
                                    //     borderRadius: BorderRadiusStyle
                                    //         .txtRoundedBorder8,
                                    //   ),
                                    //   child: Text(
                                    //     AppLocalizations.of(context)!.translate('home_string05')!,
                                    //     overflow: TextOverflow.ellipsis,
                                    //     textAlign: TextAlign.center,
                                    //     style: AppStyle.txtRobotoRomanMedium18,
                                    //   ),
                                    // ),
                                    if(disableIframe == true)
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        height: 520,
                                        child : WebViewWidget(controller: webViewController),
                                      ),
                                    Container(
                                      height: getVerticalSize(
                                        308.00,
                                      ),
                                      width: getHorizontalSize(
                                        327.00,
                                      ),
                                      margin: getMargin(
                                        top: 120,
                                      ),
                                      child: Stack(
                                        alignment: Alignment.centerRight,
                                        children: [
                                          CustomImageView(
                                            svgPath: ImageConstant
                                                .imgRectangle1085,
                                            height: getVerticalSize(
                                              305.00,
                                            ),
                                            width: getHorizontalSize(
                                              269.00,
                                            ),
                                            radius: BorderRadius.circular(
                                              getHorizontalSize(
                                                11.00,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Card(
                                              clipBehavior: Clip.antiAlias,
                                              elevation: 0,
                                              margin: const EdgeInsets.all(0),
                                              color:
                                              ColorConstant.indigo300E0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                  getHorizontalSize(
                                                    11.00,
                                                  ),
                                                ),
                                              ),
                                              child: Container(
                                                child: Image.asset('assets/images/img_home_image_01.png'),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Container(
                                              margin: getMargin(
                                                bottom: 20,
                                              ),
                                              padding: getPadding(
                                                all: 14,
                                              ),
                                              width: 170,
                                              decoration: AppDecoration
                                                  .outlineBlack9000c
                                                  .copyWith(
                                                borderRadius:
                                                BorderRadiusStyle
                                                    .roundedBorder4,
                                              ),
                                              child: Column(
                                                mainAxisSize:
                                                MainAxisSize.min,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  CustomImageView(
                                                    svgPath: ImageConstant
                                                        .imgGroup34872,
                                                    height: getVerticalSize(
                                                      77.00,
                                                    ),
                                                    width: getHorizontalSize(
                                                      137.00,
                                                    ),
                                                    margin: getMargin(
                                                      top: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            CustomImageView(
                              svgPath: ImageConstant.imgCall,
                              height: getSize(
                                24.00,
                              ),
                              width: getSize(
                                24.00,
                              ),
                              alignment: Alignment.topLeft,
                              margin: getMargin(
                                left: 81,
                                top: 42,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: size.width,
                                padding: getPadding(
                                  left: 12,
                                  top: 23,
                                  right: 12,
                                  bottom: 23,
                                ),
                                decoration:
                                AppDecoration.fillIndigo400.copyWith(
                                  borderRadius:
                                  BorderRadiusStyle.customBorderBL30,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 80,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          Container(
                                            height: 18,
                                            width: 18,
                                          ),

                                          Container(
                                            alignment: Alignment.center,
                                            child: getTextWidgetMaxLines(
                                                AppLocalizations.of(context)!.translate('home')!,
                                                16,
                                                getColorFromHex('#FFFFFF'),
                                                FontWeight.w700,
                                                TextAlign.center,
                                                FontUtil.ROBOTOBOLD, 1),
                                          ),


                                          InkWell(child: Container(
                                              height: 25,
                                              width: 25,
                                              alignment: Alignment.centerRight,
                                              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                              child: Image.asset("assets/images/translation.png",height: 18,width: 18,color: Colors.white,)),onTap: (){
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Center(child: Text(AppLocalizations.of(context)!.translate('select_language')!)),
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
                                                                                ? const Icon(
                                                                              Icons
                                                                                  .radio_button_checked,
                                                                              color: Color(0xff0B52E1),
                                                                            )
                                                                                : const Icon(
                                                                              Icons
                                                                                  .radio_button_unchecked,
                                                                              color: Color(0xff0B52E1),
                                                                            ),
                                                                          ],
                                                                        )),
                                                                    const Divider()
                                                                  ],
                                                                ),
                                                              );
                                                            })),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        style: ButtonStyle(
                                                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff0B52E1),),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },

                                                        child: const Text('cancel'),
                                                      )
                                                    ],
                                                  );
                                                });
                                          },),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: getMargin(
                                        left: 1,
                                        top: 29,
                                      ),
                                      padding: getPadding(
                                        left: 29,
                                        top: 25,
                                        right: 29,
                                        bottom: 25,
                                      ),
                                      decoration: AppDecoration
                                          .outlineBlack9001e
                                          .copyWith(
                                        borderRadius:
                                        BorderRadiusStyle.roundedBorder11,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CoinsScreen(bitcoinList,ApiUrl)));
                                            },
                                            child: CustomImageView(
                                              svgPath:
                                              ImageConstant.imgSettings,
                                              height: getSize(
                                                20.00,
                                              ),
                                              width: getSize(
                                                20.00,
                                              ),
                                              margin: getMargin(
                                                top: 4,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TrendScreen(bitcoinList[0],ApiUrl)));
                                            },
                                            child: CustomImageView(
                                              svgPath: ImageConstant.imgIcon,
                                              height: getVerticalSize(
                                                20.00,
                                              ),
                                              width: getHorizontalSize(
                                                16.00,
                                              ),
                                              margin: getMargin(
                                                top: 2,
                                                bottom: 2,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PortfolioScreen(ApiUrl)));
                                            },
                                            child: CustomImageView(
                                              svgPath:
                                              ImageConstant.imgTelevision,
                                              height: getSize(
                                                19.00,
                                              ),
                                              width: getSize(
                                                19.00,
                                              ),
                                              margin: getMargin(
                                                top: 2,
                                                bottom: 2,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TopCoinsScreen(bitcoinList,ApiUrl)));
                                            },
                                            child: CustomImageView(
                                              svgPath: ImageConstant.imgClock,
                                              height: getSize(
                                                20.00,
                                              ),
                                              width: getSize(
                                                20.00,
                                              ),
                                              margin: getMargin(
                                                top: 2,
                                                right: 2,
                                                bottom: 2,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: getMargin(
                          left: 24,
                          top: 99,
                        ),
                        child: Column(
                          children: [

                            Container(
                              alignment: Alignment.topLeft,
                              child: getTextWidgetMaxLines(
                                  AppLocalizations.of(context)!.translate('home_string06')!,
                                  36,
                                  getColorFromHex('#171717'),
                                  FontWeight.w700,
                                  TextAlign.start,
                                  FontUtil.ROBOTOBOLD, 1),
                            ),

                            Container(
                              alignment: Alignment.topLeft,
                              child: getTextWidgetMaxLines(
                                  AppLocalizations.of(context)!.translate('home_string07')!,
                                  36,
                                  getColorFromHex('#495AB2'),
                                  FontWeight.w700,
                                  TextAlign.start,
                                  FontUtil.ROBOTOBOLD, 1),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(24, 50, 24, 0),
                        alignment: Alignment.topLeft,
                        child: getTextWidgetMaxLinesVerSpaces(
                            AppLocalizations.of(context)!.translate('home_string08')!,
                            18,
                            getColorFromHex('#171717'),
                            FontWeight.w400,
                            TextAlign.start,
                            FontUtil.ROBOTOREGULAR, 8, 2),
                      ),
                      Container(
                        width: getSize(
                          80.00,
                        ),
                        height: getSize(
                          80.00,
                        ),
                        margin: getMargin(
                          left: 24,
                          top: 49,
                        ),
                        alignment: Alignment.center,
                        decoration: AppDecoration.txtFillIndigo500.copyWith(
                          borderRadius: BorderRadiusStyle.txtCircleBorder40,
                        ),
                        child: Text(
                          "1",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: AppStyle.txtPoppinsBold32,
                        ),
                      ),
                      Padding(
                        padding: getPadding(
                          left: 24,
                          top: 20,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.translate('home_string09')!,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtRobotoRomanMedium24,
                        ),
                      ),
                      Container(
                        width: getHorizontalSize(
                          252.00,
                        ),
                        margin: getMargin(
                          left: 24,
                          top: 16,
                        ),
                        child: getTextWidgetMaxLinesVerSpaces(
                            AppLocalizations.of(context)!.translate('home_string10')!,
                            18,
                            getColorFromHex('#171717'),
                            FontWeight.w400,
                            TextAlign.start,
                            FontUtil.ROBOTOREGULAR, 8, 2),
                      ),
                      Container(
                        width: getSize(
                          80.00,
                        ),
                        height: getSize(
                          80.00,
                        ),
                        margin: getMargin(
                          left: 24,
                          top: 33,
                        ),
                        alignment: Alignment.center,
                        decoration: AppDecoration.txtFillIndigo500.copyWith(
                          borderRadius: BorderRadiusStyle.txtCircleBorder40,
                        ),
                        child: Text(
                          "2",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtRobotoRomanBold32,
                        ),
                      ),
                      Padding(
                        padding: getPadding(
                          left: 24,
                          top: 17,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.translate('home_string11')!,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtRobotoRomanMedium24,
                        ),
                      ),
                      Container(
                        width: getHorizontalSize(
                          252.00,
                        ),
                        margin: getMargin(
                          left: 24,
                          top: 19,
                        ),
                        child: getTextWidgetMaxLinesVerSpaces(
                            AppLocalizations.of(context)!.translate('home_string12')!,
                            18,
                            getColorFromHex('#171717'),
                            FontWeight.w400,
                            TextAlign.start,
                            FontUtil.ROBOTOREGULAR, 8, 2),),
                      Container(
                        width: getSize(
                          80.00,
                        ),
                        height: getSize(
                          80.00,
                        ),
                        margin: getMargin(
                          left: 24,
                          top: 33,
                        ),
                        alignment: Alignment.center,
                        decoration: AppDecoration.txtFillIndigo500.copyWith(
                          borderRadius: BorderRadiusStyle.txtCircleBorder40,
                        ),
                        child: Text(
                          "3",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtPoppinsBold32,
                        ),
                      ),
                      Padding(
                          padding: getPadding(
                            left: 24,
                            top: 17,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.translate('home_string13')!,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtRobotoRomanMedium24,
                          )
                      ),
                      Container(
                          width: getHorizontalSize(
                            252.00,
                          ),
                          margin: getMargin(
                            left: 24,
                            top: 19,
                          ),
                          child: getTextWidgetMaxLinesVerSpaces(
                              AppLocalizations.of(context)!.translate('home_string14')!,
                              18,
                              getColorFromHex('#171717'),
                              FontWeight.w400,
                              TextAlign.start,
                              FontUtil.ROBOTOREGULAR, 8, 2)
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: getVerticalSize(
                            287.00,
                          ),
                          width: getHorizontalSize(
                            327.00,
                          ),
                          margin: getMargin(
                            top: 121,
                          ),
                          child: Stack(
                            alignment: Alignment.centerLeft,
                            children: [
                              Container(
                                height: 287,
                                alignment: Alignment.topLeft,
                                child: Image.asset('assets/images/img_home_image_04.png', height: 287),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: getMargin(
                          left: 24,
                          top: 49,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.translate('home_string15')!,
                          maxLines: null,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtRobotoRomanBold36,
                        ),
                      ),
                      Container(
                        margin: getMargin(
                            left: 24,
                            top: 100,
                            right: 24
                        ),
                        child: getTextWidgetMaxLinesVerSpaces(
                            AppLocalizations.of(context)!.translate('home_string16')!,
                            18,
                            getColorFromHex('#171717'),
                            FontWeight.w400, TextAlign.start, FontUtil.ROBOTOREGULAR, 8, 1.5),
                      ),
                      Padding(
                        padding: getPadding(
                          left: 24,
                          top: 49,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomImageView(
                              svgPath: ImageConstant.imgCheckmark,
                              height: getSize(
                                32.00,
                              ),
                              width: getSize(
                                32.00,
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                left: 12,
                                top: 4,
                                bottom: 5,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.translate('home_string17')!,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtRobotoRomanSemiBold18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: getPadding(
                          left: 24,
                          top: 24,
                        ),
                        child: Row(
                          children: [
                            CustomImageView(
                              svgPath: ImageConstant.imgCheckmark,
                              height: getSize(
                                32.00,
                              ),
                              width: getSize(
                                32.00,
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                left: 12,
                                top: 6,
                                bottom: 3,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.translate('home_string18')!,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtRobotoRomanSemiBold18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: getPadding(
                          left: 24,
                          top: 24,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomImageView(
                              svgPath: ImageConstant.imgCheckmark,
                              height: getSize(
                                32.00,
                              ),
                              width: getSize(
                                32.00,
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                left: 12,
                                top: 4,
                                bottom: 5,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.translate('home_string19')!,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtRobotoRomanSemiBold18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: getPadding(
                          left: 24,
                          top: 24,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomImageView(
                              svgPath: ImageConstant.imgCheckmark,
                              height: getSize(
                                32.00,
                              ),
                              width: getSize(
                                32.00,
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                left: 15,
                                top: 4,
                                bottom: 5,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.translate('home_string20')!,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtRobotoRomanSemiBold18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: getVerticalSize(
                          1150.00,
                        ),
                        width: size.width,
                        margin: getMargin(
                          top: 120,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: size.width,
                                decoration: AppDecoration.fillIndigo500,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomImageView(
                                      svgPath:
                                      ImageConstant.imgMaskgroupGray300,
                                      height: getVerticalSize(
                                        1138.00,
                                      ),
                                      width: getHorizontalSize(
                                        375.00,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: getPadding(
                                  left: 39,
                                  right: 39,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Text(
                                        AppLocalizations.of(context)!.translate('home_string21')!,
                                        maxLines: null,
                                        textAlign: TextAlign.center,
                                        style: AppStyle
                                            .txtRobotoRomanBold36WhiteA700,
                                      ),
                                    ),

                                    Card(
                                      clipBehavior: Clip.antiAlias,
                                      elevation: 0,
                                      margin: getMargin(
                                        top: 94,
                                      ),
                                      color: ColorConstant.whiteA70019,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          getHorizontalSize(
                                            44.00,
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        height: getSize(
                                          88.00,
                                        ),
                                        width: getSize(
                                          88.00,
                                        ),
                                        padding: getPadding(
                                          all: 16,
                                        ),
                                        decoration: AppDecoration
                                            .fillWhiteA70019
                                            .copyWith(
                                          borderRadius: BorderRadiusStyle
                                              .circleBorder44,
                                        ),
                                        child: Stack(
                                          children: [
                                            CustomImageView(
                                              svgPath: ImageConstant
                                                  .imgClockWhiteA700,
                                              height: getSize(
                                                56.00,
                                              ),
                                              width: getSize(
                                                56.00,
                                              ),
                                              alignment: Alignment.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: getPadding(
                                        top: 24,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.translate('home_string22')!,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtRobotoRomanMedium24WhiteA700,
                                      ),
                                    ),
                                    Container(
                                      width: getHorizontalSize(
                                        291.00,
                                      ),
                                      margin: getMargin(
                                        top: 17,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.translate('home_string23')!,
                                        maxLines: null,
                                        textAlign: TextAlign.center,
                                        style: AppStyle
                                            .txtRobotoRomanRegular18WhiteA70090,
                                      ),
                                    ),

                                    Card(
                                      clipBehavior: Clip.antiAlias,
                                      elevation: 0,
                                      margin: getMargin(
                                        top: 53,
                                      ),
                                      color: ColorConstant.whiteA70019,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          getHorizontalSize(
                                            44.00,
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        height: getSize(
                                          88.00,
                                        ),
                                        width: getSize(
                                          88.00,
                                        ),
                                        padding: getPadding(
                                          all: 16,
                                        ),
                                        decoration: AppDecoration
                                            .fillWhiteA70019
                                            .copyWith(
                                          borderRadius: BorderRadiusStyle
                                              .circleBorder44,
                                        ),
                                        child: Stack(
                                          children: [
                                            CustomImageView(
                                              svgPath: ImageConstant.imgLock,
                                              height: getSize(
                                                56.00,
                                              ),
                                              width: getSize(
                                                56.00,
                                              ),
                                              alignment: Alignment.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: getPadding(
                                        top: 23,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.translate('home_string24')!,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtRobotoRomanMedium24WhiteA700,
                                      ),
                                    ),
                                    Container(
                                      width: getHorizontalSize(
                                        291.00,
                                      ),
                                      margin: getMargin(
                                        top: 17,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.translate('home_string25')!,
                                        maxLines: null,
                                        textAlign: TextAlign.center,
                                        style: AppStyle
                                            .txtRobotoRomanRegular18WhiteA70090,
                                      ),
                                    ),

                                    Card(
                                      clipBehavior: Clip.antiAlias,
                                      elevation: 0,
                                      margin: getMargin(
                                        top: 53,
                                      ),
                                      color: ColorConstant.whiteA70019,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          getHorizontalSize(
                                            44.00,
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        height: getSize(
                                          88.00,
                                        ),
                                        width: getSize(
                                          88.00,
                                        ),
                                        padding: getPadding(
                                          left: 24,
                                          top: 20,
                                          right: 24,
                                          bottom: 20,
                                        ),
                                        decoration: AppDecoration
                                            .fillWhiteA70019
                                            .copyWith(
                                          borderRadius: BorderRadiusStyle
                                              .circleBorder44,
                                        ),
                                        child: Stack(
                                          children: [
                                            CustomImageView(
                                              svgPath: ImageConstant
                                                  .imgCheckmarkWhiteA700,
                                              height: getVerticalSize(
                                                46.00,
                                              ),
                                              width: getHorizontalSize(
                                                39.00,
                                              ),
                                              alignment: Alignment.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: getPadding(
                                        top: 23,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.translate('home_string26')!,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle.txtRobotoRomanMedium24WhiteA700,
                                      ),
                                    ),
                                    Container(
                                      width: getHorizontalSize(
                                        291.00,
                                      ),
                                      margin: getMargin(
                                        top: 17,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.translate('home_string27')!,
                                        maxLines: null,
                                        textAlign: TextAlign.center,
                                        style: AppStyle.txtRobotoRomanRegular18WhiteA70090,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: getVerticalSize(
                            300.00,
                          ),
                          margin: getMargin(
                            top: 120,
                          ),
                          child: Image.asset('assets/images/img_home_image_05.png'),
                        ),
                      ),
                      Container(
                        width: getHorizontalSize(
                          252.00,
                        ),
                        margin: getMargin(
                          left: 24,
                          top: 50,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.translate('home_string28')!,
                          maxLines: null,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtRobotoRomanBold36,
                        ),
                      ),
                      Container(

                          margin: getMargin(
                              left: 24,
                              top: 74,
                              right: 24
                          ),
                          child: getTextWidgetMaxLinesVerSpaces(
                              AppLocalizations.of(context)!.translate('home_string29')!,
                              18,
                              getColorFromHex('#171717').withOpacity(0.4),
                              FontWeight.w400,
                              TextAlign.start,
                              FontUtil.ROBOTOREGULAR, 10, 1.5)
                      ),
                      Padding(
                        padding: getPadding(
                          left: 24,
                          top: 49,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translate('home_string30')!,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtPoppinsBold24,
                                ),

                                Container(
                                  margin: getMargin(
                                    top: 6,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.translate('home_string31')!,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtRobotoRomanMedium16,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: getPadding(
                                left: 24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.translate('home_string32')!,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: AppStyle.txtPoppinsBold24,
                                  ),
                                  Container(
                                    width: getHorizontalSize(
                                      70.00,
                                    ),
                                    margin: getMargin(
                                      top: 6,
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.translate('home_string33')!,
                                      maxLines: null,
                                      textAlign: TextAlign.start,
                                      style: AppStyle.txtRobotoRomanMedium16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: getPadding(
                                left: 24,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.translate('home_string34')!,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start,
                                    style: AppStyle.txtPoppinsBold24,
                                  ),
                                  Container(
                                    width: getHorizontalSize(
                                      91.00,
                                    ),
                                    margin: getMargin(
                                      top: 5,
                                    ),
                                    child: Text(
                                      AppLocalizations.of(context)!.translate('home_string35')!,
                                      maxLines: null,
                                      textAlign: TextAlign.start,
                                      style: AppStyle.txtRobotoRomanMedium16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: getHorizontalSize(
                            264.00,
                          ),
                          margin: getMargin(
                            top: 121,
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:  AppLocalizations.of(context)!.translate('home_string36')!,
                                  style: TextStyle(
                                    color: ColorConstant.gray900,
                                    fontSize: getFontSize(
                                      36,
                                    ),
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: AppLocalizations.of(context)!.translate('home_string37')!,
                                  style: TextStyle(
                                    color: ColorConstant.indigo500,
                                    fontSize: getFontSize(
                                      36,
                                    ),
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: getPadding(
                          top: 42,
                        ),
                        child:  Container(
                          height: getVerticalSize(
                            350.00,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              PageView.builder(
                                  controller: controller,
                                  itemCount: 3,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 350,
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: getTextWidgetMaxLines(
                                                index==0?AppLocalizations.of(context)!.translate('home_string38')!
                                                    :index==1?AppLocalizations.of(context)!.translate('home_string41')!
                                                    :AppLocalizations.of(context)!.translate('home_string44')!,
                                                16,
                                                getColorFromHex('#171717'),
                                                FontWeight.w400,
                                                TextAlign.center,
                                                FontUtil.ROBOTOREGULAR, 10),
                                          ),

                                          const SizedBox(height: 10),

                                          Container(
                                            alignment: Alignment.center,
                                            child: getTextWidgetMaxLines(
                                                index==0?AppLocalizations.of(context)!.translate('home_string39')!
                                                    :index==1?AppLocalizations.of(context)!.translate('home_string42')!
                                                    :AppLocalizations.of(context)!.translate('home_string45')!,
                                                20,
                                                getColorFromHex('#171717'),
                                                FontWeight.w500,
                                                TextAlign.center,
                                                FontUtil.ROBOTOMEDIUM, 10),
                                          ),

                                          const SizedBox(height: 10),

                                          Container(
                                            alignment: Alignment.center,
                                            child: getTextWidgetMaxLines(
                                                index==0?AppLocalizations.of(context)!.translate('home_string40')!
                                                    :index==1?AppLocalizations.of(context)!.translate('home_string43')!
                                                    :AppLocalizations.of(context)!.translate('home_string46')!,
                                                16,
                                                getColorFromHex('#171717'),
                                                FontWeight.w400,
                                                TextAlign.center,
                                                FontUtil.ROBOTOREGULAR, 10),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        alignment: Alignment.bottomCenter,
                        child: SmoothPageIndicator(
                          controller: controller,
                          count: 3,
                          effect: CustomizableEffect(
                            activeDotDecoration: DotDecoration(
                              width: 40,
                              height: 10,
                              color: getColorFromHex('#495AB2'),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            dotDecoration: DotDecoration(
                              width: 10,
                              height: 10,
                              color: getColorFromHex('#495AB2'),
                              borderRadius: BorderRadius.circular(16),
                              verticalOffset: 0,
                            ),
                            spacing: 6.0,
                            inActiveColorOverride: (i) => getColorFromHex('#495AB2'),
                          ),
                        ),
                      ),
                      Container(
                        height: getVerticalSize(
                          600.00,
                        ),
                        width: size.width,
                        margin: getMargin(
                          top: 100,
                        ),
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: getVerticalSize(
                                  492.00,
                                ),
                                width: size.width,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: size.width,
                                        decoration:
                                        AppDecoration.fillIndigo500,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            CustomImageView(
                                              imagePath: ImageConstant
                                                  .imgMaskgroupGray300492x375,
                                              height: getVerticalSize(
                                                492.00,
                                              ),
                                              width: getHorizontalSize(
                                                375.00,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: getPadding(
                                          left: 72,
                                          right: 72,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: getHorizontalSize(
                                                231.00,
                                              ),
                                              child: Image.asset('assets/images/img_home_image_06.png'),
                                            ),
                                            // Padding(
                                            //   padding: getPadding(
                                            //     top: 152,
                                            //   ),
                                            //   child: Row(
                                            //     mainAxisAlignment:
                                            //     MainAxisAlignment.center,
                                            //     children: [
                                            //       CustomImageView(
                                            //         svgPath: ImageConstant
                                            //             .imgCheckmarkWhiteA70024x24,
                                            //         height: getSize(
                                            //           24.00,
                                            //         ),
                                            //         width: getSize(
                                            //           24.00,
                                            //         ),
                                            //       ),
                                            //       CustomImageView(
                                            //         svgPath: ImageConstant
                                            //             .imgVuesaxboldlocation,
                                            //         height: getSize(
                                            //           24.00,
                                            //         ),
                                            //         width: getSize(
                                            //           24.00,
                                            //         ),
                                            //         margin: getMargin(
                                            //           left: 32,
                                            //         ),
                                            //       ),
                                            //       CustomImageView(
                                            //         svgPath: ImageConstant
                                            //             .imgCallWhiteA700,
                                            //         height: getSize(
                                            //           24.00,
                                            //         ),
                                            //         width: getSize(
                                            //           24.00,
                                            //         ),
                                            //         margin: getMargin(
                                            //           left: 32,
                                            //         ),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
                                            // Padding(
                                            //   padding: getPadding(
                                            //     top: 33,
                                            //   ),
                                            //   child: Text(
                                            //     "© Copyright 2022 ",
                                            //     overflow:
                                            //     TextOverflow.ellipsis,
                                            //     textAlign: TextAlign.left,
                                            //     style: AppStyle
                                            //         .txtPoppinsRegular12,
                                            //   ),
                                            // ),
                                            Container(
                                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                                              child: Image.asset('assets/images/bitcoin_pro_home_icon_top.png'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            CustomImageView(
                              imagePath: ImageConstant.imgEllipse116,
                              height: getVerticalSize(
                                837.00,
                              ),
                              width: getHorizontalSize(
                                154.00,
                              ),
                              alignment: Alignment.bottomLeft,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  Future<void> getCoinsList() async {
    var uri = 'http://144.91.65.218:8085/Bitcoin/resources/getBitcoinCryptoListLoser?size=0&currency=USD';
    var response = await get(Uri.parse(uri));
    final data = json.decode(response.body) as Map;
    print('getBitcoinList==>>$data');
    print(data.length);
    if (data['error'] == false) {
      setState(() {
        bitcoinList.addAll(data['data']
            .map<Bitcoin>((json) => Bitcoin.fromJson(json))
            .toList());
        isLoading = false;
        print(bitcoinList.length);
      });
    } else {
      setState(() {});
    }
  }

}

class LinearSales {
  final double date;
  final double rate;
  LinearSales(this.date, this.rate);
}