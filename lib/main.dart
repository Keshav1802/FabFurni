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

// Constants
class AppConstants {
  static const String ANDROID_TEST_ID = '8920616622';
  static const String IOS_TEST_ID = '9873103345';
  static const Duration DEEPLINK_DELAY = Duration(milliseconds: 2500);
}

// Deep Link Routes
class DeepLinkRoutes {
  static const String ABOUT_US = '/about_us_screen';
  static const String TERMS = '/terms_of_condition_screen';
  static const String LOGIN = '/log_in_screen';
}

var response1;

Future<void> main() async {
  try {
    await _initializeApp();
    await _setupSmartechAndFirebase();
    await _setupOrientation();
    runApp(MyApp());
  } catch (e) {
    debugPrint('Initialization error: $e');
  }
}

Future<void> _initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
}

Future<void> _setupSmartechAndFirebase() async {
  if (Platform.isAndroid) {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Token: $fcmToken');
    await Smartech().login(AppConstants.ANDROID_TEST_ID);
  } else if (Platform.isIOS) {
    await Smartech().login(AppConstants.IOS_TEST_ID);
  }

  NetcorePX.instance.registerPxActionListener('action', _PxActionListenerImpl());
  NetcorePX.instance.registerPxDeeplinkListener(_PxDeeplinkListenerImpl());
  NetcorePX.instance.registerPxInternalEventsListener(_PxInternalEventsListener());
}

Future<void> _setupOrientation() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _hasInternet = true;
  StreamSubscription? _connectivitySubscription;
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen(_handleConnectivityChange);
    final result = await Connectivity().checkConnectivity();
    _handleConnectivityChange([result]);
  }

  void _handleConnectivityChange(List<ConnectivityResult> result) {
    if (!mounted) return;
    setState(() {
      _hasInternet = result.any((r) => r != ConnectivityResult.none);
    });
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();
    _linkSubscription = _appLinks.uriLinkStream.listen(_handleDeepLink);
  }

  void _handleDeepLink(Uri uri) {
    debugPrint('Deep Link received: $uri');
    resolveUrl(uri.toString());
    Get.toNamed(AppRoutes.htmlscreen, arguments: [response1]);
  }

  @override
  Widget build(BuildContext context) {
    return SmartechPxWidget(
      child: Sizer(
        builder: (context, orientation, deviceType) => _buildMaterialApp(context),
      ),
    );
  }

  Widget _buildMaterialApp(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [PxNavigationObserver()],
      builder: (context, child) => _hasInternet
          ? MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(1.0)),
              child: child!,
            )
          : const ConnectionLostScreen(),
      theme: ThemeData(visualDensity: VisualDensity.standard),
      translations: AppLocalization(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      title: 'FabFurni',
      initialBinding: InitialBindings(),
      home: const SplashScreen(),
      getPages: AppRoutes.pages,
    );
  }
}

// Optimize URL resolution
Future<String> resolveUrl(String url) async {
  try {
    final response = await dio.Dio().get(
      url,
      options: dio.Options(
        headers: const {"Access-Control-Expose-Headers": "location"},
        followRedirects: true,
        validateStatus: (status) => status! < 400,
      ),
    );
    response1 = response.toString();
    return response.realUri.toString();
  } catch (e) {
    debugPrint('URL resolution error: $e');
    return url;
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
    if (url == DeepLinkRoutes.ABOUT_US) {
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
