import 'package:flutter/material.dart';
import 'package:money_search/data/internetProvider.dart';
import 'package:money_search/view/Splash/splashView.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ConnectivityProvider()),

    ], child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MoneySearch',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: SplashView(),
    ));
  }
}
