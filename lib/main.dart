import 'package:flutter/material.dart';
import 'package:talkaholic/services/auth_service.dart';
import 'package:talkaholic/services/navigation_service.dart';
import 'package:talkaholic/utils.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:talkaholic/themes/theme_provider.dart';
void main() async{
  await setup();
  runApp( MainApp());
}

Future<void>setup() async{
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerServices();
}



// ignore: must_be_immutable
class MainApp extends StatelessWidget {

  final GetIt _getIt = GetIt.instance;

  late NavigationService _navigationService;
  late AuthService _authService;

   MainApp({super.key}){
      _navigationService = _getIt.get<NavigationService>();
      _authService = _getIt.get<AuthService>();
   }

  @override
  Widget build(BuildContext context) {
     return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,  // Hide debug banner
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: themeProvider.lightScheme, // Light theme colors
              scaffoldBackgroundColor: themeProvider.lightScheme.background, // Apply background color
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: themeProvider.darkScheme, // Dark theme colors
              scaffoldBackgroundColor: themeProvider.darkScheme.background, // Apply background color
            ),
        initialRoute: _authService.user !=null ? "/home" : "/login",
        routes: _navigationService.routes,
    );
  },
      ),
  );
}
}
