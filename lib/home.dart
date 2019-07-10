import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/bean/Data.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return HomePageStates();
  }
}
class HomePageStates extends State<HomePage> with AutomaticKeepAliveClientMixin{
  final wordsList = new List<AndroidInfo>();//数据源
  final wordsFont = const TextStyle(fontSize: 18.0);
  bool isRefresh = false;
  @override
  void initState() {
    super.initState();
    print("HomePage initState ...............");
    getResponseFromUrl();
  }

  //从网络获取数据
  void getResponseFromUrl() async {
    isRefresh = true;
    setState(() {});
    final dio = new Dio();
    Response response = await dio.get("http://gank.io/api/random/data/Android/20");

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
    super.build(context);
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
    return GestureDetector(
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
            ),)
    );

  }

  @override
  bool get wantKeepAlive => true;

}