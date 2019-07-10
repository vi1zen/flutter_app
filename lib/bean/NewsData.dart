import 'dart:convert' show json;

class NewsBean {

  bool error;
  List<NewsItemBean> results;

  NewsBean.fromParams({this.error, this.results});

  factory NewsBean(jsonStr) => jsonStr == null ? null : jsonStr is String ? new NewsBean.fromJson(json.decode(jsonStr)) : new NewsBean.fromJson(jsonStr);

  NewsBean.fromJson(jsonRes) {
    error = jsonRes['error'];
    results = jsonRes['results'] == null ? null : [];

    for (var resultsItem in results == null ? [] : jsonRes['results']){
      results.add(resultsItem == null ? null : new NewsItemBean.fromJson(resultsItem));
    }
  }

  @override
  String toString() {
    return '{"error": $error,"results": $results}';
  }
}

class NewsItemBean {

  int crawled;
  bool deleted;
  String id;
  String content;
  String cover;
  String created_at;
  String published_at;
  String raw;
  String title;
  String uid;
  String url;
  Map<String, dynamic> site;

  NewsItemBean.fromParams({this.crawled, this.deleted, this.id, this.content, this.cover, this.created_at, this.published_at, this.raw, this.title, this.uid, this.url, this.site});

  NewsItemBean.fromJson(jsonRes) {
    crawled = jsonRes['crawled'];
    deleted = jsonRes['deleted'];
    id = jsonRes['_id'];
    content = jsonRes['content'];
    cover = jsonRes['cover'];
    created_at = jsonRes['created_at'];
    published_at = jsonRes['published_at'];
    raw = jsonRes['raw'];
    title = jsonRes['title'];
    uid = jsonRes['uid'];
    url = jsonRes['url'];
    site = jsonRes['site'];
  }

  @override
  String toString() {
    return '{"crawled": $crawled,"deleted": $deleted,"_id": ${id != null?'${json.encode(id)}':'null'},"content": ${content != null?'${json.encode(content)}':'null'},"cover": ${cover != null?'${json.encode(cover)}':'null'},"created_at": ${created_at != null?'${json.encode(created_at)}':'null'},"published_at": ${published_at != null?'${json.encode(published_at)}':'null'},"raw": ${raw != null?'${json.encode(raw)}':'null'},"title": ${title != null?'${json.encode(title)}':'null'},"uid": ${uid != null?'${json.encode(uid)}':'null'},"url": ${url != null?'${json.encode(url)}':'null'},"site": ${site != null?'${json.encode(site)}':'null'}}';
  }
}

