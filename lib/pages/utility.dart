import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkaholic/pages/aichat.dart';
import 'package:talkaholic/pages/encryption.dart';
import 'package:talkaholic/pages/pdf2png.dart';
import 'package:talkaholic/pages/scheduledmsg.dart';
import 'package:talkaholic/pages/wordDashGame.dart';
import 'package:talkaholic/pages/pdf_gen.dart';
import 'package:talkaholic/themes/theme_provider.dart';
import 'package:talkaholic/pages/gift_chat_screen.dart';
import 'package:talkaholic/pages/scheduledmsg.dart';

class Utility extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeProvider.lightScheme.primary, // Set AppBar background based on theme
        title: Text(
          'Talkaholic Utility Page', // Update AppBar title
          style: TextStyle(color: themeProvider.lightScheme.onPrimary),
        ),
        centerTitle: true, // Center align the title
        actions: [
          // PopupMenuButton for theme selection
          PopupMenuButton<String>(
            onSelected: (String result) {
              // Handle theme selection
              if (result == 'Love') {
                themeProvider.setLoveTheme();
              } else if (result == 'Funny') {
                themeProvider.setFunnyTheme();
              } else if (result == 'Dark') {
                themeProvider.setDarkTheme();
              } else if (result == 'Light') {
                themeProvider.setLightTheme();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'Love',
                  child: Row(
                    children: [
                      Icon(Icons.favorite, color: themeProvider.lightScheme.primary),
                      SizedBox(width: 10),
                      Text('Love Theme'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Funny',
                  child: Row(
                    children: [
                      Icon(Icons.sentiment_very_satisfied, color: themeProvider.lightScheme.primary),
                      SizedBox(width: 10),
                      Text('Funny Theme'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Dark',
                  child: Row(
                    children: [
                      Icon(Icons.dark_mode, color: themeProvider.lightScheme.primary),
                      SizedBox(width: 10),
                      Text('Dark Theme'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'Light',
                  child: Row(
                    children: [
                      Icon(Icons.light_mode, color: themeProvider.lightScheme.primary),
                      SizedBox(width: 10),
                      Text('Light Theme'),
                    ],
                  ),
                ),
              ];
            },
            icon: Icon(Icons.color_lens, color: themeProvider.lightScheme.onPrimary), // Icon for theme selection
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2, // Two columns
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildGridTile(
              context,
              icon: Icons.chat_bubble,
              label: 'Gift Chat',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GiftChatScreen()),
              ),
            ),
            _buildGridTile(
              context,
              icon: Icons.rocket_launch_rounded,
              label: 'AI Chat',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),
              ),
            ),
            _buildGridTile(
              context,
              icon: Icons.lock_open_sharp,
              label: 'Encryption',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EncryptionPage()),
              ),
            ),
            _buildGridTile(
              context,
              icon: Icons.gamepad_rounded,
              label: 'Word Dash',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WordDashGame()),
              ),
            ),
            _buildGridTile(
              context,
              icon: Icons.picture_as_pdf,
              label: 'Text to PDF',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TextToPdfPage()),
              ),
            ),
           _buildGridTile(
               context,
             icon: Icons.message_sharp, 
               label: 'Schedule Message',
               onTap: () => Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => ScheduleMessagePage()),
               ),
             ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridTile(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: themeProvider.lightScheme.primary),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
