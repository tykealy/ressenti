import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ressenti',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.dark(
              primary: Colors.pink.shade400,
              secondary: Colors.pinkAccent.shade400,
              background: Colors.grey.shade900,
              onPrimary: Colors.white,
            )),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleWordPairs() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  void removeFavorite(word) {
    favorites.remove(word);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme.titleLarge?.copyWith(
        color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold);
    var appState = context.watch<MyAppState>();
    var pairList = appState.favorites;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const GeneratorPage();
        break;
      case 1:
        page = FavoritesPage(
          paireList: pairList,
        );
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.colorScheme.background,
            title: Row(
              children: [
                Text("Ressenti", style: textTheme),
              ],
            ),
          ),
          body: Row(children: [
            Expanded(
              child: Container(
                child: page,
              ),
            )
          ]),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorite',
              ),
            ],
            currentIndex: selectedIndex,
            onTap: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            backgroundColor: theme.colorScheme.background,
            selectedItemColor: theme.colorScheme.primary,
            unselectedItemColor: Colors.grey,
          ));
    });
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleWordPairs();
                },
                icon: Icon(icon),
                label: const Text("Favorite"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: const Text("Next"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displaySmall?.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asLowerCase, style: style),
      ),
    );
  }
}

class SmallCard extends StatelessWidget {
  const SmallCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final theme = Theme.of(context);

    final style = theme.textTheme.bodyLarge?.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  appState.removeFavorite(pair);
                },
                icon: const Icon(Icons.delete),
              ),
              Text(
                pair.asLowerCase,
                style: style,
              )
            ],
          )),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({
    super.key,
    required this.paireList,
  });

  final List<WordPair> paireList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'You have ${paireList.length} favorites wordpairs',
          ),
        ),
        Expanded(
          child: ListView(
            children: [for (var pair in paireList) SmallCard(pair: pair)],
          ),
        ),
      ],
    );
  }
}
