import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:machine_test/provider/auth_service_provider.dart';
import 'package:machine_test/provider/changescreen.dart';
import 'package:machine_test/provider/homescreen_provider.dart';
import 'package:machine_test/screens/homepage/home_page.dart';
import 'package:machine_test/screens/splash/splash_screen.dart';
import 'package:provider/provider.dart';



void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411.42857142857144, 843.4285714285714),
      minTextAdapt: true,
     builder: (context, child) {
       return MultiProvider(
         providers: [
           ChangeNotifierProvider(create: (context) => MainScreenNotifier()),
           ChangeNotifierProvider(create: (context) => AuthServiceProvider()),
           ChangeNotifierProvider(create: (context) => HomescreenProvider()),
         ],
         child: MaterialApp(
           title: 'Deals Dray',
           debugShowCheckedModeBanner: false,
           theme: ThemeData(
             colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
             useMaterial3: true,
             scaffoldBackgroundColor: Colors.white
           ),
           home: const SplashScreen(),
         ),
       );
     },
    );
  }
}
