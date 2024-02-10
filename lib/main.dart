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
  var favorite = <WordPair>[];

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleWordPairs() {
    if (favorite.contains(current)) {
      favorite.remove(current);
    } else {
      favorite.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme.titleLarge?.copyWith(
        color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Ressenti", style: textTheme),
          ],
        ),
        backgroundColor: theme.colorScheme.background,
      ),
      body: Center(
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
                  icon: const Icon(Icons.favorite),
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
            Text(appState.favorite.map((e) => e.asLowerCase).join(", "))
          ],
        ),
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
