import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:talkaholic/pages/home_page.dart';
import 'package:talkaholic/pages/login_page.dart';
import 'package:talkaholic/pages/register_page.dart';

class NavigationService {

  late GlobalKey<NavigatorState> _navigatorKey;

  final Map<String, Widget Function(BuildContext)> _routes = {
    "/login": (context) => LoginPage(),
    "/register": (context) => RegisterPage(),
    "/home": (context) => HomePage(),
  };

  GlobalKey<NavigatorState>? get navigatorkey {
    return _navigatorKey;
  }

  Map<String, Widget Function(BuildContext)> get routes {
      return _routes;
  }

  NavigationService() {
    _navigatorKey = GlobalKey<NavigatorState>();
  }

  void push(MaterialPageRoute route){
    _navigatorKey.currentState?.push(route);
  }

  void pushNamed(String routeName){
    _navigatorKey.currentState?.pushNamed(routeName);
  }

    void pushReplacementNamed(String routeName){
    _navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  void goback(){
    _navigatorKey.currentState?.pop();
  }


}

