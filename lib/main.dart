import 'package:flutter/material.dart';
import 'repo_list.dart';
import 'github_trending.dart';

void main() => runApp(new GitHubTrendingApp());

class TrendingTab {
  final String tabName;
  final TrendingType type;

  const TrendingTab({this.tabName, this.type});
}

const tabs = const <TrendingTab>[
  const TrendingTab(tabName: 'Today', type: TrendingType.daily),
  const TrendingTab(tabName: 'This Week', type: TrendingType.weekly),
  const TrendingTab(tabName: 'This Month', type: TrendingType.monthly)
];

class GitHubTrendingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new DefaultTabController(
        length: tabs.length,
        child: new Scaffold(
          appBar: new AppBar(
            title: const Text('GitHub Trending'),
            bottom: new TabBar(
              isScrollable: true,
              tabs: tabs.map((TrendingTab tab) {
                return new Tab(text: tab.tabName);
              }).toList(),
            ),
          ),
          body: new TabBarView(
            children: tabs.map((TrendingTab tab) {
              return new RepoListWidget(type: tab.type);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
