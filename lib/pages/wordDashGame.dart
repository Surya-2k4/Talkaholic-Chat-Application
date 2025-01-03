import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(WordDashApp());
}

class WordDashApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WordDashGame(),
    );
  }
}

class WordDashGame extends StatefulWidget {
  @override
  _WordDashGameState createState() => _WordDashGameState();
}

class _WordDashGameState extends State<WordDashGame> {
  // List of words with their hints and categories
  final List<Map<String, String>> masterWordList = [
    {"word": "apple", "hint": "A red or green fruit", "category": "Fruit"},
    {"word": "banana", "hint": "A yellow fruit", "category": "Fruit"},
    {"word": "zebra", "hint": "An animal with stripes", "category": "Animal"},
    {"word": "ocean", "hint": "Large body of water", "category": "Nature"},
    {"word": "planet", "hint": "A celestial body orbiting a star", "category": "Space"},
    {"word": "python", "hint": "A programming language", "category": "Technology"},
    {"word": "violin", "hint": "A string instrument", "category": "Music"},
    {"word": "chocolate", "hint": "A sweet brown treat", "category": "Food"},
    {"word": "volcano", "hint": "A mountain that erupts", "category": "Nature"},
    {"word": "parrot", "hint": "A colorful talking bird", "category": "Animal"},
  ];

  late List<Map<String, String>> words; // Current word list
  int currentWordIndex = 0;
  String currentWord = "";
  String displayWord = "";
  String hint = "";
  String category = "";
  TextEditingController _controller = TextEditingController();
  int hearts = 3;
  int points = 0;
  int timer = 30;
  bool gameOver = false;
  bool isHintUsed = false;

  late Timer countdownTimer;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    _shuffleWordList();
    startNewWord();
    startTimer();
  }

  // Shuffle the word list to create a fresh experience
  void _shuffleWordList() {
    words = List.from(masterWordList)..shuffle(random);
  }

  // Start a new word in the game
  void startNewWord() {
    if (currentWordIndex < words.length) {
      setState(() {
        currentWord = words[currentWordIndex]["word"]!;
        hint = words[currentWordIndex]["hint"]!;
        category = words[currentWordIndex]["category"]!;
        displayWord = _getUnderscoreWord(currentWord);
        isHintUsed = false;
        timer = 30; // Reset the timer for the new word
      });
    } else {
      setState(() {
        gameOver = true;
      });
      countdownTimer.cancel();
    }
  }

  // Generate underscores for the word
  String _getUnderscoreWord(String word) {
    return List.generate(word.length, (index) => "_").join(" ");
  }

  // Handle the user's guess
  void checkGuess(String guess) {
    if (guess == currentWord) {
      setState(() {
        points += 10;
        currentWordIndex++;
        startNewWord();
      });
    } else {
      setState(() {
        hearts -= 1;
        if (hearts <= 0) {
          gameOver = true;
          countdownTimer.cancel();
        }
      });
    }
    _controller.clear();
  }

  // Show a hint: reveal one letter randomly
  void showHint() {
    if (!isHintUsed) {
      setState(() {
        isHintUsed = true;
        int indexToReveal = random.nextInt(currentWord.length - 2) + 1;
        List<String> displayList = displayWord.split(" ");
        displayList[indexToReveal] = currentWord[indexToReveal];
        displayWord = displayList.join(" ");
      });
    }
  }

  // Start the countdown timer
  void startTimer() {
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (this.timer <= 1) {
        setState(() {
          gameOver = true;
        });
        countdownTimer.cancel();
      } else {
        setState(() {
          this.timer -= 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Word Dash", style: TextStyle(fontSize: screenWidth * 0.07)),
        centerTitle: true,
      ),
      body: gameOver
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Game Over!", style: TextStyle(fontSize: 30, color: Colors.red, fontWeight: FontWeight.bold)),
                  Text("Your Score: $points", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        hearts = 3;
                        points = 0;
                        currentWordIndex = 0;
                        _shuffleWordList();
                        gameOver = false;
                      });
                      startNewWord();
                      startTimer();
                    },
                    child: Text("Restart"),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Category: $category", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Hint: $hint", style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
                  SizedBox(height: 20),
                  Text(displayWord, style: TextStyle(fontSize: 36, letterSpacing: 8)),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Time Left: $timer", style: TextStyle(fontSize: 18)),
                      SizedBox(width: 20),
                      Text("Hearts: ${"❤️" * hearts}", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: "Your Guess",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(onPressed: () => checkGuess(_controller.text.toLowerCase()), child: Text("Submit Guess")),
                  SizedBox(height: 10),
                  ElevatedButton(onPressed: showHint, child: Text("Show Hint")),
                ],
              ),
            ),
    );
  }
}
