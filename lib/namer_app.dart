import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyNamerApp extends StatelessWidget {
  const MyNamerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  // [] list, {} set
  var history = <WordPair>[];
  var favorites = <WordPair>[]; // generic 타입명시

  GlobalKey? historyListKey;

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  // []는 안들어갈수있다는 의미
  // ? 는 null 가능
  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}

// StatelessWidget는 스스로 변경불가능 State를 거쳐야함.
// 하나의 위젯에서만 사용되는 상태는 State에 넣지 않고 stateful로 해야함.
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// _는 private
class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default: // fail fast 원칙
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // 화면 전환 애니메이션
    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        child: page,
      ),
    );

    // Scaffold를 래핑했는데 공간의 양에 따라 위젯트리 변경하게 콜백해줌
    // 창크기, 가로세로, 일부위젯의 크기가 바뀔때
    // 여기서 픽셀은 논리적 단위임, 하드웨어 독립적
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 450) {
          // 하단 네비 바
          return Column(
            children: [
              Expanded(child: mainArea),
              SafeArea(
                child: BottomNavigationBar(
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.favorite),
                      label: 'Favorites',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.backspace),
                      label: 'Login',
                    ),
                  ],
                  currentIndex: selectedIndex,
                  onTap: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
            ],
          );
        } else {
          // 사이드 네비 바
          return Scaffold(
            body: Row(
              children: [
                SafeArea(
                  // 반응성
                  // Wrap은 공간에 따라서 다음줄로 넘어감 Row와 비슷함.
                  // FittedBox는 크기 스케일로 맞춤
                  // 노치, 상태표시줄 등에 가려지지 않음
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600, // 라벨 표시
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.favorite),
                        label: Text('Favorites'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      print('selected: $value');
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            ),
          );
        }
      }),
    );
  }
}

class GeneratorPage extends StatelessWidget {
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
          Expanded(
            flex: 3,
            child: HistoryListView(),
          ),
          SizedBox(height: 10),
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            //mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var favorites = appState.favorites;

    if (favorites.isEmpty) {
      return Center(
        child: Text(' No favorites yet.'),
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.all(30),
        child: Text('You have ${appState.favorites.length} favorites:'),
      ),
      Expanded(
        child: GridView(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            childAspectRatio: 400 / 80,
          ),
          children: [
            for (var pair in appState.favorites)
              ListTile(
                leading: IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () {
                    appState.removeFavorite(pair);
                  },
                ),
                title: Text(
                  pair.asLowerCase,
                ),
              ),
          ],
        ),
      ),
    ]);
  }
}

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     var pair = appState.current;
//     IconData favIcon;
//     if (appState.favorites.contains(pair)) {
//       favIcon = Icons.favorite;
//     } else {
//       favIcon = Icons.favorite_border;
//     }

//     // bar body nav 분리
//     return Scaffold(
//       body: Center(
//         child: Column(
//           // 기본 : 상단의 중간에 배치됨
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('A random idea: something한글?'),
//             BigCard(pair: pair),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               //mainAxisSize: MainAxisSize.min,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () {
//                     appState.toggleFavorite();
//                   },
//                   icon: Icon(favIcon),
//                   label: Text('Like'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     appState.getNext();
//                   },
//                   child: Text('Next'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ! : bang 연산자 null이 가능한경우 인지 했다는 뜻
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme
          .onBackground, // 사본에서 변경사항 primary에 맞는 잘 대비되는색 secondary 등 많음
    );

    return Card(
      color: theme.colorScheme.background,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        //child: Text(pair.asLowerCase, style: style),
        child: Text("${pair.first}${pair.second}",
            style: style), // 스크린리더 정상작동을 위함 필요없음
      ),
    );
  }
}

class HistoryListView extends StatefulWidget {
  const HistoryListView({Key? key}) : super(key: key);

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  /// Needed so that [MyAppState] can tell [AnimatedList] below to animate
  /// new items.
  final _key = GlobalKey();

  /// Used to "fade out" the history items at the top, to suggest continuation.
  static const Gradient _maskingGradient = LinearGradient(
    // This gradient goes from fully transparent to fully opaque black...
    colors: [Colors.transparent, Colors.black],
    // ... from the top (transparent) to half (0.5) of the way to the bottom.
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    appState.historyListKey = _key;

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      // This blend mode takes the opacity of the shader (i.e. our gradient)
      // and applies it to the destination (i.e. our animated list).
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        padding: EdgeInsets.only(top: 100),
        initialItemCount: appState.history.length,
        itemBuilder: (context, index, animation) {
          final pair = appState.history[index];
          return SizeTransition(
            sizeFactor: animation,
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  appState.toggleFavorite(pair);
                },
                icon: appState.favorites.contains(pair)
                    ? Icon(Icons.favorite, size: 12)
                    : SizedBox(),
                label: Text(
                  pair.asLowerCase,
                  semanticsLabel: pair.asPascalCase,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
