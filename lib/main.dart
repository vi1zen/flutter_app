import 'package:flutter/material.dart';
import 'package:flutter_app/home.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/news.dart';
import 'package:flutter_app/picture.dart';

void main()  {
  runApp(MyApp());
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(systemNavigationBarColor: Color(0xFF000000),
      systemNavigationBarDividerColor: null,
      statusBarColor: null,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomNavWidget(),
    );
  }

}

class BottomNavWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return BottomNavState();
  }
}
class BottomNavState extends State<BottomNavWidget>{
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    NewsPage(),
    PicturePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: EdgeInsets.only(top: 20),child:
      _widgetOptions.elementAt(_selectedIndex),),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("首页")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.library_books),
                title: Text("新闻")
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.photo),
                title: Text("美图")
            )
          ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}