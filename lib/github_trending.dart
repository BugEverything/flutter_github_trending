import 'dart:io';
import 'package:html/parser.dart' show parse;
import 'dart:convert';
import 'dart:async';

class Repo {
  String name;
  String link;
  String intro;
  String language;
  String starsToday;
  String fork;
  String star;

  Repo(
      {this.name,
      this.link,
      this.intro,
      this.language,
      this.starsToday,
      this.fork,
      this.star});

  @override
  String toString() {
    return 'name: $name; link: $link; intro: $intro; language: $language; starsToday: $starsToday; fork: $fork; star: $star';
  }
}

class GitHubTrending {
  Future<List<Repo>> _sendRequest(Map<String, String> param) async {
    final httpClient = new HttpClient();
    final uri = new Uri.https('github.com', '/trending');
    final request = await httpClient.getUrl(uri);
    final response = await request.close();
    final responseBody = await response.transform(UTF8.decoder).join();
    return _parseHtml(responseBody);
  }

  List<Repo> _parseHtml(content) {
    final baseUrl = 'https://github.com';
    final document = parse(content);
    var reposList = document.getElementsByClassName('repo-list');
    var lis = reposList[0].getElementsByTagName('li');
    var repos = new List<Repo>();
    for (var li in lis) {
      var repo = new Repo();
      var href = li.children[0].getElementsByTagName('a')[0].attributes['href'];
      repo.name = href.substring(1);
      repo.link = baseUrl + href;
      repo.intro = li.children[2].getElementsByTagName('p')[0].text.trim();
      var children = li.children[3].children;
      var length = children.length;
      if (length == 5) {
        repo.language = children[0].children[1].text.trim();
      }
      repo.starsToday = children[--length].text.trim().split(' ')[0];
      length--;
      repo.fork = children[--length].text.trim();
      repo.star = children[--length].text.trim();
      repos.add(repo);
    }
    return repos;
  }

  Future<List<Repo>> getToday() {
    return _sendRequest({'since': 'daily'});
  }

  Future<List<Repo>> getWeek() {
    return _sendRequest({'since': 'weekly'});
  }

  Future<List<Repo>> getMonth() {
    return _sendRequest({'since': 'monthly'});
  }
}
