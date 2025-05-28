import 'package:book_shelf/providers/book_shelf_provider.dart';
import 'package:book_shelf/repositories/book_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:book_shelf/services/proxy_manager.dart';
import 'package:book_shelf/providers/settings/locale_provider.dart';
import 'package:book_shelf/providers/settings/theme_provider.dart';
import 'package:book_shelf/ui/main_app.dart';


import 'package:book_shelf/models/book.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  final bookBox = await initHive();
  final repository = BookRepository(bookBox);

  final themeProvider = ThemeProvider();
  final localeProvider = LocaleProvider();

  await Future.wait([
    themeProvider.loadPreferences(),
    localeProvider.loadPreferences(),
  ]);

  final prefs = await SharedPreferences.getInstance();
  final proxyManager = await ProxyManager.create(prefs);

  var app = BookShelfApp(themeProvider: themeProvider, localeProvider: localeProvider);

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => BookRepository(bookBox)),
        ChangeNotifierProvider.value(value: BookshelfProvider(repository)),
        ChangeNotifierProvider.value(value: proxyManager),
      ],
      child: app,
    ),
  );
}


