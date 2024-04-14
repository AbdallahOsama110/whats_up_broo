import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/utils/cache_helper.dart';
import 'provider/myTheme.dart';
import 'provider/user_provider.dart';
import 'screens/home_screen.dart';
import 'screens/sign_in.dart';
import 'screens/splash_screen.dart';
import 'widgets/dark_theme.dart';
import 'widgets/light_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyTheme>(
            create: (context) => MyTheme()..isDark = CacheHelper.getData(key: 'isDark') ?? false,),
        ChangeNotifierProvider<UserProvider>(
            create: (context) => UserProvider()),
      ],
      child: Consumer<MyTheme>(
        builder: (context, myTheme, child) {
          return MaterialApp(
            themeMode: myTheme.isDark ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: lightTheme(),
            darkTheme: darkTheme(),
            home: CacheHelper.getData(key: 'email') != null && CacheHelper.getData(key: 'password') != null
                ? const MyCustomSplashScreen(nextScreen: HomeScreen())
                : MyCustomSplashScreen(nextScreen: SignInScreen()),
          );
        },
      ),
    );
  }
}