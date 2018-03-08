import 'package:flutter/material.dart';
import 'github_trending.dart';
import 'dart:async';

class RepoListWidget extends StatefulWidget {
  final List<Repo> _repos = [];
  final TrendingType type;

  RepoListWidget({this.type});

  @override
  State<StatefulWidget> createState() => new _RepoListWidgetState();
}

class _RepoListWidgetState extends State<RepoListWidget> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    print('initState: ' + widget._repos.length.toString());
    if (widget._repos.isEmpty) {
      _handleRefresh();
    }
    super.initState();
  }

  Widget _buildItem(context, index) {
    return new RepoItem(widget._repos[index]);
  }

  Future<Null> _handleRefresh() {
    print('_handleRefresh');
    GitHubTrending gitHubTrending = new GitHubTrending();
    return gitHubTrending.get(widget.type).then((repos) {
      print('getToday: ' + repos.length.toString());
      if (mounted) {
        setState(() {
          widget._repos.clear();
          widget._repos.addAll(repos);
        });
      } else {
        widget._repos.clear();
        widget._repos.addAll(repos);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _handleRefresh,
      child: new ListView.builder(
        itemCount: widget._repos.length,
        itemBuilder: _buildItem,
      ),
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
            color: new Color(repo.langColor),
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
