import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talkaholic/models/user_profile.dart';
import 'package:talkaholic/pages/chat_page.dart';
import 'package:talkaholic/pages/login_page.dart';
import 'package:talkaholic/pages/utility.dart';
import 'package:talkaholic/services/alert_service.dart';
import 'package:talkaholic/services/auth_service.dart';
import 'package:talkaholic/services/database_services.dart';
import 'package:talkaholic/services/navigation_service.dart';
import 'package:talkaholic/widgets/chat_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt _getIt = GetIt.instance;

  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;
  late DatabaseServices _databaseServices;

  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
    _databaseServices = _getIt.get<DatabaseServices>();

    _pages = [
      ChatScreen(
        databaseServices: _databaseServices,
        authService: _authService,
        navigationService: _navigationService,
        alertService: _alertService,
      ),
      Utility(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view, size: 30),
              label: 'Utility',
            ),
          ],
          backgroundColor: Colors.blueAccent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}

/// ChatScreen Widget for displaying the list of users
class ChatScreen extends StatelessWidget {
  final DatabaseServices databaseServices;
  final AuthService authService;
  final NavigationService navigationService;
  final AlertService alertService;

  const ChatScreen({
    super.key,
    required this.databaseServices,
    required this.authService,
    required this.navigationService,
    required this.alertService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        actions: [
          IconButton(
            onPressed: () async {
              bool result = await authService.logout();
              // if (result) {
                alertService.showToast(
                  text: "Successfully logged out!",
                  icon: Icons.check,
                );
              //navigationService.pushReplacementNamed("/login");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context)=> LoginPage()));
             // }
            },
            color: Colors.red,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: StreamBuilder(
            stream: databaseServices.getUserProfiles(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Unable to Load Data"),
                );
              }
              if (snapshot.hasData && snapshot.data != null) {
                final users = snapshot.data!.docs;
                if (users.isEmpty) {
                  return const Center(
                    child: Text("No Users Found"),
                  );
                }
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    UserProfile user = users[index].data();
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ChatTile(
                        userProfile: user,
                        onTap: () async {
                          final chatExists = await databaseServices.checkChatExists(
                            authService.user!.uid,
                            user.uid!,
                          );
                          if (!chatExists) {
                            await databaseServices.createNewChat(
                              authService.user!.uid,
                              user.uid!,
                            );
                          }
                        Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ChatPage(
      chatUser: user,
    ),
  ),
);
                        },
                      ),
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
