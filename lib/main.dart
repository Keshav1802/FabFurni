import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' as dio;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keshav_s_application2/presentation/splash_screen/splash_screen.dart';
import 'package:keshav_s_application2/widgets/connection_lost.dart';
import 'package:sizer/sizer.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:smartech_base/smartech_base.dart';
import 'package:smartech_nudges/listener/px_listener.dart';
import 'package:smartech_nudges/netcore_px.dart';
import 'package:smartech_nudges/px_widget.dart';
import 'package:smartech_nudges/tracker/route_obersver.dart';
import 'package:url_launcher/url_launcher.dart';
import 'core/app_export.dart';
import 'package:location/location.dart';
import 'dart:io' show Platform;
import 'dart:io';
import 'package:http/http.dart' as http;

var response1;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  // if(Smartech().getUserIdentity().toString().isEmpty){
  if (Platform.isAndroid) {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);
    Smartech().login('8920616622');
  }
  if (Platform.isIOS) {
    Smartech().login('9873103345');
  }

  // }

  //  if(Platform.isAndroid){
  //    var mapandroid={
  //      "name":"keshav",
  //      "update":"sent by android platform"
  //    };
  //    print(mapandroid);
  //    Smartech().updateUserProfile(mapandroid);
  //  }
  // if(Platform.isIOS){
  //   var mapiOS={
  //     "name":"keshav",
  //     "update":"sent by iOS platform"
  //   };
  //   print(mapiOS);
  //   Smartech().updateUserProfile(mapiOS);
  // }

  //Smartech().setUserIdentity('9873103345');
  NetcorePX.instance
      .registerPxActionListener('action', _PxActionListenerImpl());
  NetcorePX.instance.registerPxDeeplinkListener(_PxDeeplinkListenerImpl());
  NetcorePX.instance
      .registerPxInternalEventsListener(_PxInternalEventsListener());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
    runApp(MyApp());
  });

  Smartech().onHandleDeeplink((String? smtDeeplinkSource,
      String? smtDeeplink,
      Map<dynamic, dynamic>? smtPayload,
      Map<dynamic, dynamic>? smtCustomPayload) async {
    // String deeplink1=smtDeeplink!;
    // print(deeplink1);
    print('$smtDeeplink');
    print('$smtDeeplink');

    Future.delayed(const Duration(milliseconds: 2500), () async {
      if (smtDeeplinkSource == 'PushNotification') {
        print(smtDeeplink);
        String deeplink = smtDeeplink!.substring(0, smtDeeplink.indexOf('?'));
        if (deeplink == '/about_us_screen') {
          Get.toNamed(AppRoutes.aboutUsScreen);
        }
        if (deeplink == '/terms_of_condition_screen') {
          Get.toNamed(AppRoutes.termsOfConditionScreen);
        }
        if (deeplink == '/log_in_screen') {
          Get.toNamed(AppRoutes.logInScreen);
        }
        if (smtDeeplink.contains("https")) {
          print("navigate to browser with url");
          final Uri _url = Uri.parse(smtDeeplink);
          if (!await launchUrl(_url)) throw 'Could not launch $_url';
          // await
          // FlutterWebBrowser.openWebPage(url: smtDeeplink);
        }
      }
      if (smtDeeplinkSource == 'InAppMessage') {
        // print(smtDeeplink);
        if (smtDeeplink == '/about_us_screen') {
          Get.toNamed(AppRoutes.aboutUsScreen);
        }
        if (smtDeeplink == '/terms_of_condition_screen') {
          Get.toNamed(AppRoutes.termsOfConditionScreen);
        }
        if (smtDeeplink == '/log_in_screen') {
          Get.toNamed(AppRoutes.logInScreen);
        }
        if (smtDeeplink!.contains("https")) {
          print("navigate to browser with url");
          final Uri _url = Uri.parse(smtDeeplink);
          if (!await launchUrl(_url)) throw 'Could not launch $_url';
          // await
          // FlutterWebBrowser.openWebPage(url: smtDeeplink);
        }
      }
    });
  });
  // handleUrl(
  //     'https://elink.savmoney.me/vtrack?clientid=170681&ul=BgVRBlNEBR5TX15DB154R1VASw4KWVYdTx4=&ml=BA9VSFJEA1MESw==&sl=dUolSDdrSTF9Y0tUClBWXxpFBBUIWF0BSkwLU0xQ&pp=0&c=0000&fl=X0ISRBECGk1DVkFQFkkWVURGSw8MWVhLew88UHkiXFZrI1M=&ext=');
  resolveUrl(
      'https://elink.savmoney.me/vtrack?clientid=170681&ul=BgVRBlNEBR5TX15DB154R1VASw4KWVYdTx4=&ml=BA9VSFJEA1MESw==&sl=dUolSDdrSTF9Y0tUClBWXxpFBBUIWF0BSkwLU0xQ&pp=0&c=0000&fl=X0ISRBECGk1DVkFQFkkWVURGSw8MWVhLew88UHkiXFZrI1M=&ext=');
  getLocation();
}

Future<String> resolveUrl(String url) async {
  String? res;
  try {
    // Make a GET request
    final response = await dio.Dio().get(
      url,
      options: dio.Options(
        headers: {
          "Access-Control-Expose-Headers": "location",
        },
      ),
    );
    print('Status code: ${response.statusCode}');
    print('Repsonse: ${response}');
    response1=response.toString();
    if (response.statusCode == 200 || response.statusCode == 302) {
      // Successfully resolved the link, return the resulting URL
      // res=response..toString();
      return response.realUri.toString();
    } else {
      print('Error resolving link: ${response.statusCode}');
    }
  } catch (e) {
    print('Error resolving link: $e');
  }

  // If URL doesn't start with 'elink', return the original URL
  return res!;
  //return url;
}

void handleUrl(String url) async {
  var client = http.Client();

  // Create a GET request
  var request = http.Request('GET', Uri.parse(url));

  // Send the request without following redirects automatically
  var response = await client.send(request);

  // Check the status code and headers
  print('Status code: ${response.statusCode}');
  print('Headers: ${response.headers}');

  if (response.statusCode == 200 || response.statusCode == 302) {
    // Access the Location header for the redirect
    var location = response.headers['location'];
    print(response.request!.url.toString());
    print('Redirect Location: $location');
  } else {
    print('No redirect');
  }

  client.close();
}

// String resolvedUrl = await resolveUrl(url);
// print("Resolved URL: $resolvedUrl");
// Use the resolved URL in your app logic

void getLocation() async {
  Location location = Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  // ignore: unused_local_variable
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  _locationData = await location.getLocation();
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool hasInternet = true;
  bool isOffline = false;
  StreamSubscription? subscription;
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    initDeepLinks();
    subscription =
        Connectivity().onConnectivityChanged.listen(showConnectivitySnackBar);
    startChecking();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    subscription!.cancel();

    super.dispose();
  }

  Future<void> startChecking() async {
    final List<ConnectivityResult> result =
        await Connectivity().checkConnectivity();
    showConnectivitySnackBar(result);
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      debugPrint('onAppLink: $uri');
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    debugPrint('Link: $uri');
    resolveUrl(uri.toString());
    // Navigator.of(context).push(MaterialPageRoute(
    //   builder: (context) => HtmlPAGE(),
    // ));
    Get.toNamed(AppRoutes.htmlscreen,arguments: [response1]);
    // Get.toNamed(AppRoutes.aboutUsScreen);
    // _navigatorKey.currentState?.pushNamed(uri.fragment);
  }

  void showConnectivitySnackBar(List<ConnectivityResult> result) {
    setState(() {
      hasInternet = result != ConnectivityResult.none;
    });

    // final message = hasInternet
    //     ? 'You have again ${result.toString()}'
    //     : 'You have no internet';
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SmartechPxWidget(
      child: Sizer(builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorObservers: [PxNavigationObserver()],
          builder: (context, child) {
            return hasInternet
                ? MediaQuery(
                    child: child!,
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: TextScaler.linear(1.0)),
                  )
                : ConnectionLostScreen();
          },
          theme: ThemeData(
            visualDensity: VisualDensity.standard,
          ),
          translations: AppLocalization(),
          locale: Get.deviceLocale, //for setting localization strings
          fallbackLocale: Locale('en', 'US'),
          title: 'FabFurni',
          initialBinding: InitialBindings(),
          home: SplashScreen(),
          // initialRoute: AppRoutes.initialRoute,
          getPages: AppRoutes.pages,
        );
      }),
    );
  }
}

class _PxActionListenerImpl extends PxActionListener {
  @override
  void onActionPerformed(String action) {
    print('PXAction: $action');
  }
}

class _PxDeeplinkListenerImpl extends PxDeeplinkListener {
  @override
  void onLaunchUrl(String url) {
    if (url == '/about_us_screen') {
      Get.toNamed(AppRoutes.aboutUsScreen);
    }
    print('PXDeeplink: $url');
  }
}

class _PxInternalEventsListener extends PxInternalEventsListener {
  @override
  void onEvent(String eventName, Map dataFromHansel) {
    Map<String, dynamic> newMap =
        Map<String, dynamic>.from(dataFromHansel.map((key, value) {
      return MapEntry(key.toString(), value);
    }));
    Smartech().trackEvent(eventName, newMap);
    debugPrint('PXEvent: $eventName eventData : $dataFromHansel');
  }
}
