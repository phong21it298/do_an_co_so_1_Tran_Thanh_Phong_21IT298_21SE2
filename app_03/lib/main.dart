import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_03/viewmodels/auth_view_model.dart';
import 'package:app_03/views/login_screen.dart';
import 'package:app_03/views/register_screen.dart';
import 'package:app_03/viewmodels/home_view_model.dart';
import 'package:app_03/views/home_screen.dart';
import 'package:app_03/viewmodels/search_history_viewmodel.dart';
import 'package:app_03/views/search_history_screen.dart';
import 'package:app_03/viewmodels/ai_view_model.dart';
import 'package:app_03/views/ai_generator_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => SearchHistoryViewModel()),
        ChangeNotifierProvider(create: (_) => AiViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthViewModel>().currentUser;
    final isLoggedIn = currentUser != null;

    return MaterialApp(
      initialRoute: isLoggedIn ? '/home' : '/login', //Check user is LoggedIn.
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/history': (context) => SearchHistoryScreen(),
        '/ai_gen': (context) => AiGeneratorScreen(),
      },
    );
  }
}
