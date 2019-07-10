import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/bean/NewsData.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return new NewsPageStates();
  }
}
class NewsPageStates extends State<NewsPage>{
  final newsList = new List<NewsItemBean>();//数据源
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
    Response response = await dio.get("http://gank.io/api/xiandu/data/id/appinn/count/10/page/1");

    NewsBean newsBean = NewsBean(response.data);
    final list = newsBean.results;
    for (var value in list) {
      print(value.title);
    }
    setState(() {
      newsList.clear();
      if(!newsBean.error){
        newsList.addAll(list);
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
    }else if(newsList.isEmpty){
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
            itemCount: newsList.length,
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context,i){
              return buildRow(newsList[i],i);
            },
          )
      );
    }
  }

  Widget buildRow(NewsItemBean newsItem, int index) {
    return new Dismissible(key: new Key(newsItem.uid),
        onDismissed: (direction){
          setState(() {
            newsList.remove(newsItem);
          });
        },
        child: new GestureDetector(
          onTap: (){
            Navigator.of(context).push(new MaterialPageRoute(builder: (context){
              return new Scaffold(
                appBar: new AppBar(
                  title: new Text(newsItem.title),
                ),
                body: WebView(
                  initialUrl: newsItem.url,
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
                      child: Text(newsItem.title,style: new TextStyle(fontWeight: FontWeight.w600),),
                    ),
                    ],
                  ),
                  Image.network(newsItem.cover == null ? "" : newsItem.cover),
                  new Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Text(
                        "发布时间：" + newsItem.created_at,
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