
import 'package:flutter/material.dart';
import 'package:book_shelf/ui/screens/login_screen.dart';
import 'package:book_shelf/ui/screens/sign_up_screen.dart';
import 'package:book_shelf/ui/screens/main_screen.dart';


import 'package:provider/provider.dart';
import 'package:book_shelf/providers/settings/theme_provider.dart';
import 'package:book_shelf/providers/settings/locale_provider.dart';

import 'package:book_shelf/generated/i10n/app_localizations.dart';
import 'package:book_shelf/global_keys.dart';



class BookShelfApp extends StatelessWidget {
  final ThemeProvider themeProvider;
  final LocaleProvider localeProvider;

  const BookShelfApp({
    super.key,
    required this.themeProvider,
    required this.localeProvider
  });

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider(create: (_) => localeProvider),
      ],
      child: buildApp(),
    );

  }

  Widget buildApp(){

    return Consumer2<ThemeProvider, LocaleProvider>(
      builder: (context, theme, locale, _) {
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: theme.themeMode,
          locale: locale.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          scaffoldMessengerKey: scaffoldMessengerKey,
          initialRoute: '/login',
          routes: {
            '/login': (context) => LoginScreen(),
            '/register': (context) => SignUpScreen(),
            '/home': (context) => buildMainScreen(),
          },
        );
      },
    );
  }

  Widget buildMainScreen(){
    return Scaffold(
      body: MainScreen(),
    );
  }
}









