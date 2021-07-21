import 'package:flutter/material.dart';
import 'package:formvalidation/pages/home_page.dart';
import 'package:formvalidation/pages/login_page.dart';
import 'package:formvalidation/pages/register_page.dart';
import 'package:formvalidation/user_preferences/user_preferences.dart';

import 'bloc/provider.dart';
import 'pages/product_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreferences();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new UserPreferences();
    print(prefs.token);
    return Provider(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'login',
      routes: {
        'login': (BuildContext context) => LoginPage(),
        'register': (BuildContext context) => RegisterPage(),
        'home': (BuildContext context) => HomePage(),
        'product': (BuildContext context) => ProductPage(),
      },
    ));
  }
}
