import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/splash_screen.dart';
import 'screens/privacy_policy_page.dart';
import 'screens/terms_of_service_page.dart';
import 'screens/about_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _darkMode = false;

  void _toggleTheme() {
    setState(() => _darkMode = !_darkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2048 Puzzle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEDAA5C),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEDAA5C),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/game': (context) => Game2048(onToggleTheme: _toggleTheme, isDark: _darkMode),
        '/privacy': (context) => const PrivacyPolicyPage(),
        '/terms': (context) => const TermsOfServicePage(),
        '/about': (context) => const AboutPage(),
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Game constants & helpers
// ─────────────────────────────────────────────────────────────

const int kBoardSize = 4;

Color tileColor(int value) {
  switch (value) {
    case 2:
      return const Color(0xFFEEE4DA);
    case 4:
      return const Color(0xFFEDE0C8);
    case 8:
      return const Color(0xFFF2B179);
    case 16:
      return const Color(0xFFF59563);
    case 32:
      return const Color(0xFFF67C5F);
    case 64:
      return const Color(0xFFF65E3B);
    case 128:
      return const Color(0xFFEDCF72);
    case 256:
      return const Color(0xFFEDCC61);
    case 512:
      return const Color(0xFFEDC850);
    case 1024:
      return const Color(0xFFEDC53F);
    case 2048:
      return const Color(0xFFEDC22E);
    default:
      return const Color(0xFFCDC1B4); // empty or > 2048
  }
}

Color tileForeground(int value) {
  return value <= 4 ? const Color(0xFF776E65) : Colors.white;
}

double tileFontSize(int value) {
  if (value < 100) return 32;
  if (value < 1000) return 26;
  return 20;
}

// ─────────────────────────────────────────────────────────────
//  Game screen
// ─────────────────────────────────────────────────────────────

class Game2048 extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;

  const Game2048({super.key, required this.onToggleTheme, required this.isDark});

  @override
  State<Game2048> createState() => _Game2048State();
}

class _Game2048State extends State<Game2048> {
  final _random = Random();
  final _audioPlayer = AudioPlayer();

  List<List<int>> _board = List.generate(kBoardSize, (_) => List.filled(kBoardSize, 0));

  int _score = 0;
  int _highScore = 0;
  int _moves = 0;
  int _merges = 0;
  int _gamesPlayed = 0;
  bool _soundOn = true;
  bool _gameOver = false;
  bool _won = false;
  bool _continueAfterWin = false;

  @override
  void initState() {
    super.initState();
    _loadAndStart();
  }

  // ─── Persistence ───

  Future<void> _loadAndStart() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScore = prefs.getInt('highScore') ?? 0;
      _soundOn = prefs.getBool('sound') ?? true;
      _gamesPlayed = prefs.getInt('gamesPlayed') ?? 0;
    });
    _startGame();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highScore', _highScore);
    await prefs.setBool('sound', _soundOn);
    await prefs.setInt('gamesPlayed', _gamesPlayed);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound(String fileName) async {
    if (!_soundOn) return;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource('sounds/$fileName'));
  }

  // ─── Game control ───

  void _startGame() {
    setState(() {
      _board = List.generate(kBoardSize, (_) => List.filled(kBoardSize, 0));
      _score = 0;
      _moves = 0;
      _merges = 0;
      _gameOver = false;
      _won = false;
      _continueAfterWin = false;
      _gamesPlayed++;
      _addTile();
      _addTile();
    });
    _save();
  }

  void _addTile() {
    final empty = <Point<int>>[];
    for (int r = 0; r < kBoardSize; r++) {
      for (int c = 0; c < kBoardSize; c++) {
        if (_board[r][c] == 0) empty.add(Point(r, c));
      }
    }
    if (empty.isEmpty) return;
    final p = empty[_random.nextInt(empty.length)];
    _board[p.x][p.y] = _random.nextInt(10) < 9 ? 2 : 4;
  }

  // ─── Merge logic ───

  List<int> _mergeRow(List<int> row) {
    final tiles = row.where((e) => e != 0).toList();
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] == tiles[i + 1]) {
        tiles[i] *= 2;
        _score += tiles[i];
        _merges++;
        if (_score > _highScore) _highScore = _score;
        if (tiles[i] == 2048 && !_continueAfterWin) _won = true;
        tiles.removeAt(i + 1);
      }
    }
    while (tiles.length < kBoardSize) tiles.add(0);
    return tiles;
  }

  bool _boardChanged(List<List<int>> before, List<List<int>> after) {
    for (int r = 0; r < kBoardSize; r++) {
      for (int c = 0; c < kBoardSize; c++) {
        if (before[r][c] != after[r][c]) return true;
      }
    }
    return false;
  }

  List<List<int>> _copyBoard() =>
      _board.map((row) => List<int>.from(row)).toList();

  void _move(String direction) {
    if (_gameOver) return;
    final before = _copyBoard();
    final mergesBefore = _merges;

    setState(() {
      switch (direction) {
        case 'left':
          for (int r = 0; r < kBoardSize; r++) {
            _board[r] = _mergeRow(_board[r]);
          }
        case 'right':
          for (int r = 0; r < kBoardSize; r++) {
            _board[r] = _mergeRow(_board[r].reversed.toList()).reversed.toList();
          }
        case 'up':
          for (int c = 0; c < kBoardSize; c++) {
            final col = List.generate(kBoardSize, (r) => _board[r][c]);
            final merged = _mergeRow(col);
            for (int r = 0; r < kBoardSize; r++) _board[r][c] = merged[r];
          }
        case 'down':
          for (int c = 0; c < kBoardSize; c++) {
            final col = List.generate(kBoardSize, (r) => _board[r][c]);
            final merged = _mergeRow(col.reversed.toList()).reversed.toList();
            for (int r = 0; r < kBoardSize; r++) _board[r][c] = merged[r];
          }
      }

      if (_boardChanged(before, _board)) {
        _moves++;
        _addTile();
        _checkGameOver();
        if (_gameOver) {
          _playSound('gameover.wav');
        } else if (_won) {
          _playSound('win.wav');
        } else if (_merges > mergesBefore) {
          _playSound('merge.wav');
        } else {
          _playSound('move.wav');
        }
      }
    });

    _save();
  }

  void _checkGameOver() {
    for (int r = 0; r < kBoardSize; r++) {
      for (int c = 0; c < kBoardSize; c++) {
        if (_board[r][c] == 0) return;
        if (r < kBoardSize - 1 && _board[r][c] == _board[r + 1][c]) return;
        if (c < kBoardSize - 1 && _board[r][c] == _board[r][c + 1]) return;
      }
    }
    _gameOver = true;
  }

  // ─── Overlays ───

  Widget _buildGameOverOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 12,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Game Over!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text('Score: $_score', style: const TextStyle(fontSize: 18)),
                Text('High Score: $_highScore', style: const TextStyle(fontSize: 18)),
                Text('Moves: $_moves', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                Text('Merges: $_merges', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _startGame,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Play Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWinOverlay() {
    return Container(
      color: Colors.amber.withOpacity(0.75),
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 12,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('You Win! 🎉', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('You reached 2048!', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: _startGame,
                      child: const Text('New Game'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        _won = false;
                        _continueAfterWin = true;
                      }),
                      child: const Text('Keep Going'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Drawer ───

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFEDAA5C)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '2048',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Slide. Merge. Win.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text('New Game'),
            onTap: () {
              Navigator.pop(context);
              _startGame();
            },
          ),
          ListTile(
            leading: Icon(_soundOn ? Icons.volume_up : Icons.volume_off),
            title: Text(_soundOn ? 'Sound: On' : 'Sound: Off'),
            onTap: () {
              setState(() => _soundOn = !_soundOn);
              _save();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            title: Text(widget.isDark ? 'Light Mode' : 'Dark Mode'),
            onTap: () {
              widget.onToggleTheme();
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/about');
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/privacy');
            },
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Terms of Service'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/terms');
            },
          ),
        ],
      ),
    );
  }

  // ─── Board UI ───

  Widget _buildBoard() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFBBADA0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: kBoardSize * kBoardSize,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: kBoardSize,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          final r = index ~/ kBoardSize;
          final c = index % kBoardSize;
          final value = _board[r][c];
          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: tileColor(value),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: value == 0
                  ? null
                  : Text(
                      '$value',
                      style: TextStyle(
                        fontSize: tileFontSize(value),
                        fontWeight: FontWeight.bold,
                        color: tileForeground(value),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScoreBox(String label, int value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFBBADA0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w600)),
          Text(
            '$value',
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: const Text(
          '2048',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'New Game',
            onPressed: _startGame,
          ),
        ],
      ),
      body: GestureDetector(
        onPanEnd: (details) {
          if (_gameOver) return;
          final v = details.velocity.pixelsPerSecond;
          if (v.dx.abs() > v.dy.abs()) {
            _move(v.dx > 0 ? 'right' : 'left');
          } else {
            _move(v.dy > 0 ? 'down' : 'up');
          }
        },
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildScoreBox('SCORE', _score),
                      const SizedBox(width: 12),
                      _buildScoreBox('BEST', _highScore),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Join tiles to reach 2048!',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      Text(
                        'Moves: $_moves',
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Center(child: _buildBoard()),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/privacy'),
                  child: const Text(
                    'Privacy Policy · Terms of Service',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
            if (_won) _buildWinOverlay(),
            if (_gameOver) _buildGameOverOverlay(),
          ],
        ),
      ),
    );
  }
}
