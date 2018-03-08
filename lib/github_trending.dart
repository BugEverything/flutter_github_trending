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
  int langColor;

  Repo(
      {this.name,
      this.link,
      this.intro,
      this.language,
      this.starsToday,
      this.fork,
      this.star,
      this.langColor});

  @override
  String toString() {
    return 'name: $name; link: $link; intro: $intro; language: $language; starsToday: $starsToday; fork: $fork; star: $star; langColor: $langColor';
  }
}

class GitHubTrending {
  Future<List<Repo>> _sendRequest(Map<String, String> param) async {
    final httpClient = new HttpClient();
    final uri = new Uri.https('github.com', '/trending', param);
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
      try {
        var repo = new Repo();
        var href =
            li.children[0].getElementsByTagName('a')[0].attributes['href'];
        repo.name = href.substring(1);
        repo.link = baseUrl + href;
        repo.intro = li.children[2].getElementsByTagName('p')[0].text.trim();
        var children = li.children[3].children;
        var length = children.length;
        if (length == 5) {
          repo.language = children[0].children[1].text.trim();
          String langColor = children[0].children[0].attributes['style'];
          langColor = '0xFF' + langColor.split('#')[1].replaceFirst(';', '');
          repo.langColor = int.parse(langColor);
        }
        repo.starsToday = children[--length].text.trim().split(' ')[0];
        length--;
        repo.fork = children[--length].text.trim();
        repo.star = children[--length].text.trim();
        repos.add(repo);
      } catch (e) {
        print('Exception when parsing a repo: ' + e.toString());
      }
    }
    return repos;
  }

  Future<List<Repo>> get(TrendingType type) {
    final param = <String, String>{};
    switch (type) {
      case TrendingType.daily:
        param['since'] = 'daily';
        break;
      case TrendingType.weekly:
        param['since'] = 'weekly';
        break;
      case TrendingType.monthly:
        param['since'] = 'monthly';
        break;
      default:
        break;
    }
    return _sendRequest(param);
  }
}

enum TrendingType { daily, weekly, monthly }
