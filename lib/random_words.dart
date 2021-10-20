import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _randomWordPair = <WordPair>[];
  final _favorites = Set<WordPair>();

  void showFavorites() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext builder) {
      final tiles = _favorites.map((pair) => ListTile(
          title:
              Text(pair.asCamelCase, style: const TextStyle(fontSize: 16.0))));

      final dividedTiles =
          ListTile.divideTiles(tiles: tiles, context: context).toList();

      return Scaffold(
        appBar: AppBar(title: const Text('Favorites')),
        body: ListView(children: dividedTiles),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('WordPair Generator'),
          actions: <Widget>[
            IconButton(onPressed: showFavorites, icon: Icon(Icons.list))
          ],
        ),
        body: _buildList());
  }

  Widget _buildRow(WordPair pair) {
    final alreadyFavorite = _favorites.contains(pair);

    return ListTile(
        title: Text(pair.asCamelCase, style: const TextStyle(fontSize: 18.0)),
        trailing: Icon(
          alreadyFavorite ? Icons.favorite : Icons.favorite_border,
          color: alreadyFavorite ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            if (alreadyFavorite) {
              _favorites.remove(pair);
            } else {
              _favorites.add(pair);
            }
          });
        });
  }

  Widget _buildList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, item) {
          if (item.isOdd) return const Divider();

          final index = item ~/ 2;

          if (index >= _randomWordPair.length) {
            _randomWordPair.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_randomWordPair[index]);
        });
  }
}
