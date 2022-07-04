import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tajammul_customer_app/Environments/Environment.dart';
import 'package:tajammul_customer_app/Models/Business.dart';
import 'package:tajammul_customer_app/Models/HiveProduct.dart';
import 'package:tajammul_customer_app/Providers/OTPExpiredProvider.dart';
import 'package:tajammul_customer_app/Providers/userProvider.dart';
import 'package:tajammul_customer_app/Screens/Splash/Splash_main.dart';
import 'package:tajammul_customer_app/Services/GraphQLConfiguration.dart';
import 'package:tajammul_customer_app/routes.dart';
import 'Models/CartProduct.dart';
import 'Providers/UpdateIndexProvider.dart';
import 'colors.dart';
import 'package:hive_flutter/hive_flutter.dart';

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
ConnectivityResult connectionStatus = ConnectivityResult.none;
//final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();
Environment env = Environment();


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //assign env for end point
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  Box? box;
  HiveProduct hp = HiveProduct()
  ..business=Business()
  ..currentCategory = ""
  ..cartData = []
  ..categoryList=[]
  ..categoryProduct={}
  ;
  await Hive.initFlutter();
  Hive.registerAdapter<HiveProduct>(HiveProductAdapter());
  Hive.registerAdapter<Business>(BusinessAdapter());
  Hive.registerAdapter(CartProductAdapter());
  box = await Hive.openBox<HiveProduct>('cart');
  box.add(hp);
  //call background notification when received
  String environment = const String.fromEnvironment('ENVIRONMENT', defaultValue: Environment.live);

  //set env for end point
  env.initConfig(environment);


  //all providers for state management
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MyApp()
    );
  });
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UpdateIndexProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => OTPExpiredProvider())
      ],
      child: GraphQLProvider(
        client: graphQLConfiguration.client,
        child: MaterialApp(
          theme: ThemeData.light().copyWith(
            scrollbarTheme: const ScrollbarThemeData().copyWith(

              thumbColor: MaterialStateProperty.all(blueGrey),
              trackBorderColor:
              MaterialStateProperty.all(const Color(0xFF707070)),
            ),
          ),
          localizationsDelegates: const [
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en', 'US')],
          debugShowCheckedModeBanner: false,
          //scaffoldMessengerKey: snackbarKey,
          home: SplashScreen(),
          //routes: routes,
          onGenerateRoute: (route)=>Routes.onGenerateRoute(route),
        ),
      ),
    );
  }

}

