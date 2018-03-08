import 'package:flutter/material.dart';
import 'github_trending.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GitHubTrending gitHubTrending = new GitHubTrending();
    gitHubTrending.getToday().then((repos) {
      print(repos[0]);
    });
    return new MaterialApp(
        title: 'GitHub Trending',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text('GitHub Trending'),
          ),
          body: new Center(
            child: new Text('GitHub Trending'),
          ),
        ));
  }
}
