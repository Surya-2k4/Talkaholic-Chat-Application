import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GiftChatScreen extends StatefulWidget {
  @override
  _GiftChatScreenState createState() => _GiftChatScreenState();
}

class _GiftChatScreenState extends State<GiftChatScreen> {
  TextEditingController _user1Controller = TextEditingController();
  TextEditingController _user2Controller = TextEditingController();
  List<String> _messagesUser1 = [];
  List<String> _messagesUser2 = [];
  List<bool> _showGiftBox1 = [];
  List<bool> _showGiftBox2 = [];
  List<bool> _messageVisible1 = [];
  List<bool> _messageVisible2 = [];
  List<double> _giftOpacity1 = [];
  List<double> _giftOpacity2 = [];

  void _sendMessage(bool isUser1) {
    setState(() {
      if (isUser1) {
        _messagesUser1.add(_user1Controller.text);
        _showGiftBox1.add(true); // Show giftbox animation for User 1
        _messageVisible1.add(false); // Initially hide message for User 1
        _giftOpacity1.add(1.0); // Set full opacity for gift for User 1
        _user1Controller.clear();
      } else {
        _messagesUser2.add(_user2Controller.text);
        _showGiftBox2.add(true); // Show giftbox animation for User 2
        _messageVisible2.add(false); // Initially hide message for User 2
        _giftOpacity2.add(1.0); // Set full opacity for gift for User 2
        _user2Controller.clear();
      }
    });
  }

  // Function to handle giftbox click and show the message
  void _revealMessage(bool isUser1, int index) {
    setState(() {
      if (isUser1) {
        _messageVisible1[index] = true; // Reveal message for User 1
      } else {
        _messageVisible2[index] = true; // Reveal message for User 2
      }
    });

    // Hide message and giftbox after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        if (isUser1) {
          _giftOpacity1[index] = 0.0; // Fade out giftbox for User 1
          _showGiftBox1[index] = false; // Hide giftbox for User 1
          _messageVisible1[index] = false; // Hide message for User 1
        } else {
          _giftOpacity2[index] = 0.0; // Fade out giftbox for User 2
          _showGiftBox2[index] = false; // Hide giftbox for User 2
          _messageVisible2[index] = false; // Hide message for User 2
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giffyy Chat.🎀"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messagesUser1.length + _messagesUser2.length,
              itemBuilder: (context, index) {
                if (index % 2 == 0) {
                  int user1Index = index ~/ 2;
                  return Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        _revealMessage(true, user1Index); // Reveal message for User 1
                      },
                      child: Column(
                        children: [
                          // Show Giftbox animation or the message
                          _showGiftBox1.isNotEmpty && _showGiftBox1[user1Index]
                              ? AnimatedOpacity(
                                  opacity: _giftOpacity1[user1Index],
                                  duration: Duration(milliseconds: 500),
                                  child: Lottie.asset(
                                    'assets/giftbox_animation.json',
                                    height: 150, // Larger size for the giftbox
                                  ),
                                )
                              : Container(),
                          // Show message if it is revealed
                          _messageVisible1.isNotEmpty && _messageVisible1[user1Index]
                              ? AnimatedOpacity(
                                  opacity: _giftOpacity1[user1Index],
                                  duration: Duration(milliseconds: 500),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(top: 8, left: 20, right: 60),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: LinearGradient(colors: [
                                        Colors.blueAccent,
                                        Colors.lightBlueAccent,
                                      ]),
                                    ),
                                    child: Text(
                                      _messagesUser1[user1Index],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  );
                } else {
                  int user2Index = index ~/ 2;
                  return Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        _revealMessage(false, user2Index); // Reveal message for User 2
                      },
                      child: Column(
                        children: [
                          // Show Giftbox animation or the message
                          _showGiftBox2.isNotEmpty && _showGiftBox2[user2Index]
                              ? AnimatedOpacity(
                                  opacity: _giftOpacity2[user2Index],
                                  duration: Duration(milliseconds: 500),
                                  child: Lottie.asset(
                                    'assets/giftbox_animation.json',
                                    height: 150, // Larger size for the giftbox
                                  ),
                                )
                              : Container(),
                          // Show message if it is revealed
                          _messageVisible2.isNotEmpty && _messageVisible2[user2Index]
                              ? AnimatedOpacity(
                                  opacity: _giftOpacity2[user2Index],
                                  duration: Duration(milliseconds: 500),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(top: 8, right: 20, left: 60),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      gradient: LinearGradient(colors: [
                                        Colors.purpleAccent,
                                        Colors.deepPurpleAccent,
                                      ]),
                                    ),
                                    child: Text(
                                      _messagesUser2[user2Index],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          // User 1 TextField and Send Button
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _user1Controller,
                    decoration: InputDecoration(
                      hintText: "User 1 Type your message...",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      setState(() {});
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _user1Controller.text.isEmpty
                      ? null
                      : () {
                          _sendMessage(true); // Send message for User 1
                        },
                  color: _user1Controller.text.isEmpty ? Colors.grey : Colors.blue,
                ),
              ],
            ),
          ),
          // User 2 TextField and Send Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _user2Controller,
                    decoration: InputDecoration(
                      hintText: "User 2 Type your message...",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      setState(() {});
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _user2Controller.text.isEmpty
                      ? null
                      : () {
                          _sendMessage(false); // Send message for User 2
                        },
                  color: _user2Controller.text.isEmpty ? Colors.grey : Colors.purple,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
