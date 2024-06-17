import 'package:flutter/material.dart';
import 'package:notes/notes_page.dart';
import 'package:notes/notes_provider.dart';
import 'package:notes/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NotesProvider(),
      child: const NotesApp(),
    ),
  );
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const NotesSplashScreen(),
        '/home': (context) => const NotesPage(),
      },
    );
  }
}
