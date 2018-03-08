import 'package:flutter/material.dart';
import 'github_trending.dart';

class RepoListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RepoListWidgetState();
}

class _RepoListWidgetState extends State<RepoListWidget> {
  final List<Repo> _repos = [];

  @override
  void initState() {
    print('initState');
    GitHubTrending gitHubTrending = new GitHubTrending();
    gitHubTrending.getToday().then((repos) {
      print('getToday: ' + repos.length.toString());
      setState(() {
        _repos.clear();
        _repos.addAll(repos);
      });
    });
    super.initState();
  }

  Widget _buildItem(context, index) {
    return new RepoItem(_repos[index]);
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: _repos.length,
      itemBuilder: _buildItem,
    );
  }
}

class RepoItem extends StatelessWidget {
  final Repo repo;

  RepoItem(this.repo);

  @override
  Widget build(BuildContext context) {
    var name = new Text(
      repo.name,
      style: new TextStyle(
          fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.blue),
    );
    var intro = new Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: new Text(repo.intro, softWrap: true),
    );
    var children = <Widget>[];
    if (repo.language != null) {
      children.add(new Row(
        children: <Widget>[
          new Icon(
            Icons.fiber_manual_record,
            color: const Color(0xFFDEA584),
            size: 20.0,
          ),
          new Text(
            repo.language,
            style: new TextStyle(fontSize: 12.0),
          ),
        ],
      ));
    }
    Widget star = new Row(
      children: <Widget>[
        new Icon(
          Icons.star,
          color: Colors.grey[600],
          size: 20.0,
        ),
        new Text(
          repo.star,
          style: new TextStyle(fontSize: 12.0),
        ),
      ],
    );
    var fork = new Row(
      children: <Widget>[
        new Icon(
          Icons.device_hub,
          color: Colors.grey[600],
          size: 20.0,
        ),
        new Text(
          repo.fork,
          style: new TextStyle(fontSize: 12.0),
        ),
      ],
    );
    var starsToday = new Row(
      children: <Widget>[
        new Icon(
          Icons.star,
          color: Colors.grey[600],
          size: 20.0,
        ),
        new Text(
          repo.starsToday + ' stars today',
          style: new TextStyle(fontSize: 12.0),
        )
      ],
    );
    children.add(star);
    children.add(fork);
    children.add(starsToday);
    return new Card(
        child: new Container(
      margin: const EdgeInsets.all(8.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          name,
          intro,
          new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children)
        ],
      ),
    ));
  }
}
