import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/bean/Data.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PicturePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new PicturePageStates();
  }
}
class PicturePageStates extends State<PicturePage>{
  final wordsList = new List<AndroidInfo>();//数据源
  final wordsFont = const TextStyle(fontSize: 18.0);
  bool isRefresh = false;
  @override
  void initState() {
    super.initState();
    getResponseFromUrl();
  }

  //从网络获取数据
  void getResponseFromUrl() async {
    isRefresh = true;
    setState(() {});
    final dio = new Dio();
    Response response = await dio.get("http://gank.io/api/data/福利/10/1");

    AndroidNewsBean androidNewsBean = AndroidNewsBean(response.data);
    final list = androidNewsBean.results;
    for (var value in list) {
      print(value.toString());
    }
    setState(() {
      wordsList.clear();
      if(!androidNewsBean.error){
        wordsList.addAll(list);
      }
      isRefresh = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: buildListView(),
    );
  }

  Widget buildListView(){
    if(isRefresh){
      return new GestureDetector(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.black87),),Text("正在加载...")],
          ),
        ),
        onTap: getResponseFromUrl,
      );
    }else if(wordsList.isEmpty){
      return new GestureDetector(
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Icon(Icons.error,size: 50.0,),Text("Oops,服务器错误!")],
          ),
        ),
        onTap: getResponseFromUrl,
      );
    }else{
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
                  title: new Text("福利图"),
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
              child: Image.network(androidInfo.url),
            ),),
        ));


  }

}