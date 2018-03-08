import 'package:flutter/material.dart';
import 'repo_list.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'GitHub Trending',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('GitHub Trending'),
            ),
            body: new RepoListWidget()));
  }
}
