import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool dark = false;

  void toggleTheme() {
    setState(() => dark = !dark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: dark ? ThemeData.dark() : ThemeData.light(),
      home: Game2048(onToggleTheme: toggleTheme),
    );
  }
}

class Game2048 extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const Game2048({super.key, required this.onToggleTheme});

  @override
  State<Game2048> createState() => _Game2048State();
}

class _Game2048State extends State<Game2048> {
  static const int size = 4;

  List<List<int>> board =
  List.generate(size, (_) => List.filled(size, 0));

  final random = Random();
  final player = AudioPlayer();

  int score = 0;
  int highScore = 0;

  bool soundOn = true;
  bool gameOver = false;

  // 📊 ANALYTICS (local simple tracking)
  int moves = 0;
  int merges = 0;
  int gamesPlayed = 0;

  @override
  void initState() {
    super.initState();
    load();
  }

  // ================= LOAD =================
  Future load() async {
    final p = await SharedPreferences.getInstance();

    score = p.getInt("score") ?? 0;
    highScore = p.getInt("highScore") ?? 0;
    soundOn = p.getBool("sound") ?? true;

    gamesPlayed = p.getInt("games") ?? 0;

    startGame();
  }

  Future save() async {
    final p = await SharedPreferences.getInstance();

    p.setInt("score", score);
    p.setInt("highScore", highScore);
    p.setBool("sound", soundOn);
    p.setInt("games", gamesPlayed);
  }

  // ================= GAME CONTROL =================

  void startGame() {
    board = List.generate(size, (_) => List.filled(size, 0));
    score = 0;
    gameOver = false;

    addTile();
    addTile();

    gamesPlayed++;
    save();

    setState(() {});
  }

  void addTile() {
    List<Point> empty = [];

    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (board[i][j] == 0) empty.add(Point(i, j));
      }
    }

    if (empty.isEmpty) {
      checkGameOver();
      return;
    }

    var p = empty[random.nextInt(empty.length)];
    board[p.x.toInt()][p.y.toInt()] = random.nextBool() ? 2 : 4;
  }

  // ================= GAME OVER =================

  void checkGameOver() {
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (board[i][j] == 0) return;

        if (i < size - 1 && board[i][j] == board[i + 1][j]) return;
        if (j < size - 1 && board[i][j] == board[i][j + 1]) return;
      }
    }

    setState(() => gameOver = true);
  }

  // ================= LOGIC =================

  List<int> merge(List<int> row) {
    row.removeWhere((e) => e == 0);

    for (int i = 0; i < row.length - 1; i++) {
      if (row[i] == row[i + 1]) {
        row[i] *= 2;
        score += row[i];
        merges++;

        if (score > highScore) highScore = score;

        row[i + 1] = 0;
      }
    }

    row.removeWhere((e) => e == 0);

    while (row.length < size) row.add(0);

    return row;
  }

  // ================= MOVES =================

  void moveLeft() {
    setState(() {
      moves++;

      for (int i = 0; i < size; i++) {
        board[i] = merge(board[i]);
      }

      addTile();
      save();
      checkGameOver();
    });
  }

  void moveRight() {
    setState(() {
      moves++;

      for (int i = 0; i < size; i++) {
        board[i] =
            merge(board[i].reversed.toList()).reversed.toList();
      }

      addTile();
      save();
      checkGameOver();
    });
  }

  void moveUp() {
    setState(() {
      moves++;

      for (int j = 0; j < size; j++) {
        List<int> col = [];

        for (int i = 0; i < size; i++) {
          col.add(board[i][j]);
        }

        col = merge(col);

        for (int i = 0; i < size; i++) {
          board[i][j] = col[i];
        }
      }

      addTile();
      save();
      checkGameOver();
    });
  }

  void moveDown() {
    setState(() {
      moves++;

      for (int j = 0; j < size; j++) {
        List<int> col = [];

        for (int i = 0; i < size; i++) {
          col.add(board[i][j]);
        }

        col = merge(col.reversed.toList()).reversed.toList();

        for (int i = 0; i < size; i++) {
          board[i][j] = col[i];
        }
      }

      addTile();
      save();
      checkGameOver();
    });
  }

  // ================= UI COLORS (AAA STYLE) =================

  Color color(int v) {
    switch (v) {
      case 2:
        return Colors.grey.shade200;
      case 4:
        return Colors.grey.shade300;
      case 8:
        return Colors.orange.shade300;
      case 16:
        return Colors.orange;
      case 32:
        return Colors.deepOrange;
      case 64:
        return Colors.redAccent;
      case 128:
        return Colors.yellow;
      case 256:
        return Colors.amber;
      case 512:
        return Colors.green;
      case 1024:
        return Colors.teal;
      case 2048:
        return Colors.blue;
      default:
        return Colors.grey.shade100;
    }
  }

  // ================= GAME OVER UI =================

  Widget gameOverWidget() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "GAME OVER",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text("Score: $score"),
                Text("Moves: $moves"),
                Text("Merges: $merges"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: startGame,
                  child: const Text("Restart"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("Score: $score"),
            Text("High: $highScore"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: startGame,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),

      body: Stack(
        children: [
          GestureDetector(
            onPanEnd: (d) {
              final v = d.velocity.pixelsPerSecond;

              if (v.dx.abs() > v.dy.abs()) {
                v.dx > 0 ? moveRight() : moveLeft();
              } else {
                v.dy > 0 ? moveDown() : moveUp();
              }
            },

            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: size * size,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: size,
                  ),
                  itemBuilder: (c, i) {
                    int r = i ~/ size;
                    int col = i % size;
                    int v = board[r][col];

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: color(v),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 3,
                            color: Colors.black12,
                          )
                        ],
                      ),
                      child: Center(
                        child: Text(
                          v == 0 ? "" : "$v",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          if (gameOver) gameOverWidget(),
        ],
      ),
    );
  }
}