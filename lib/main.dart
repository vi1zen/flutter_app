import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/bean/Data.dart';
import 'package:webview_flutter/webview_flutter.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        primaryColor: Colors.white
      ),
      home: new RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new RandomWordsStates();
  }
}
class RandomWordsStates extends State<RandomWords>{
  final wordsList = new List<AndroidInfo>();//数据源
  final wordsFont = const TextStyle(fontSize: 18.0);

  @override
  void initState() {
    super.initState();
    getResponseFromUrl();
  }

  //从网络获取数据
  void getResponseFromUrl() async {
    final dio = new Dio();
    Response response = await dio.get("http://gank.io/api/random/data/Android/20");
//    print(response.data.toString());

    AndroidNewsBean androidNewsBean = AndroidNewsBean(response.data);
    final list = androidNewsBean.results;
    for (var value in list) {
      print(value.toString());
    }
    setState(() {
      wordsList.clear();
      wordsList.addAll(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Gank.io by Flutter"),
        actions: <Widget>[new IconButton(icon: new Icon(Icons.refresh), onPressed: getResponseFromUrl)],
      ),
      body: buildWords(),
    );
  }

  Widget buildWords(){
    return new Container(
      child:  new ListView.builder(
        itemCount: wordsList.length,
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (context,i){
            return buildRow(wordsList[i],i);
          },
        )
    );

  }

  Widget buildRow(AndroidInfo androidInfo, int index) {
    return new Dismissible(key: new Key(androidInfo.desc),
      onDismissed: (direction){
        setState(() {
          wordsList.remove(androidInfo);
        });
      },
      child: new GestureDetector(
        onTap: (){
          print(androidInfo.desc);
          Navigator.of(context).push(new MaterialPageRoute(builder: (context){
            return new Scaffold(
              appBar: new AppBar(
                title: new Text(androidInfo.desc),
              ),
              body: WebView(
                initialUrl: androidInfo.url,
                javascriptMode: JavascriptMode.unrestricted,
              ),
            );
          }
          ));
        },
        child: new Card(
          elevation: 5.0,
          child: new Padding(padding: EdgeInsets.all(10.0),
            child: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[Padding(
                  padding: EdgeInsets.only(top: 16.0,bottom: 16.0),
                ),
                Expanded(
                  child: Text(androidInfo.desc,style: new TextStyle(fontWeight: FontWeight.w600),),
                ),
                ],
              ),
              Image.network(androidInfo.images == null ? "" : androidInfo.images[0]),
              new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Text(
                    "发布时间：" + androidInfo.createdAt,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  new Text(
                    "作者:" + androidInfo.who,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              ],
          ),
          ),),
      ));


  }

}