import 'package:flutter/material.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/news.dart';
import 'package:flutter_app/picture.dart';

void main() {
  runApp(MyApp());
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFF000000),
      systemNavigationBarDividerColor: null,
      statusBarColor: null,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BottomNavState();
  }
}

class BottomNavState extends State<MyApp> {
  int _selectedIndex = 0;
  var pageController;

  List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    NewsPage(),
    PicturePage(),
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0, keepPage: true);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: PageView.builder(
          controller: pageController,
          onPageChanged: _onPageChange,
          itemCount: _widgetOptions.length,
          itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(top: 20),
              child: _widgetOptions.elementAt(index))),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books), title: Text("新闻")),
          BottomNavigationBarItem(icon: Icon(Icons.photo), title: Text("美图"))
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          pageController.jumpToPage(index);
        },
      ),
    ));
  }

  void _onPageChange(int index) {
    setState(() {
      if (_selectedIndex != index) {
        _selectedIndex = index;
      }
    });
  }
}
