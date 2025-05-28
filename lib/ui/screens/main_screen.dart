import 'package:book_shelf/providers/book_shelf_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:book_shelf/ui/pages/book_shelf_page.dart';
import 'package:book_shelf/ui/pages/home_page.dart';
import 'package:book_shelf/ui/pages/user_page.dart';
import 'package:book_shelf/ui/elements/menu_button.dart';
import 'package:book_shelf/ui/elements/menu_button_bar.dart';

import 'package:book_shelf/generated/i10n/app_localizations.dart';
import 'package:book_shelf/providers/home_provider.dart';
import 'package:book_shelf/services/book_service.dart';

import 'package:book_shelf/services/proxy_manager.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final proxyManager = Provider.of<ProxyManager>(context, listen: false);
    var bookService = BookService(proxyManager);

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomeProvider(bookService)),
          // ChangeNotifierProvider(create: (ctx) => BookshelfProvider(ctx.read<BookRepository>())),
        ],
        child:buildApp()
    );
  }

  Widget buildApp(){
    return  Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.appTitle), centerTitle: true),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) => setState(() => currentPageIndex = index),
        children: [
          HomePage(),
          BookShelfPage(),
          UserPage(),
        ],
      ),
      persistentFooterButtons: [
        BottomMenuBar(
          currentIndex: currentPageIndex,
          pageController: pageController,
          items: [
            MenuItem(icon: Icons.home, label: AppLocalizations.of(context)!.home, index: 0),
            MenuItem(icon: Icons.library_books, label: AppLocalizations.of(context)!.bookRack, index: 1),
            MenuItem(icon: Icons.account_circle, label: AppLocalizations.of(context)!.user, index: 2),
          ],
        ),
      ],
    );
  }
}