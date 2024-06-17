import 'package:flutter/material.dart';
import 'package:notes/notes_page.dart';

class NotesSplashScreen extends StatefulWidget {
  const NotesSplashScreen({super.key});

  @override
  _NotesSplashScreenState createState() => _NotesSplashScreenState();
}

class _NotesSplashScreenState extends State<NotesSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animationLeft;
  late Animation<Offset> _animationRight;
  late Animation<Offset> _animationIconLeft;
  late Animation<Offset> _animationIconRight;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animationLeft = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _animationRight = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _animationIconLeft = Tween<Offset>(
      begin: const Offset(-0.5, 0.0),
      end: const Offset(-1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _animationIconRight = Tween<Offset>(
      begin: const Offset(0.5, 0.0),
      end: const Offset(1.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const NotesPage()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width * 0.4;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SlideTransition(
            position: _animationLeft,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height,
                color: Colors.blue.shade50,
              ),
            ),
          ),
          SlideTransition(
            position: _animationRight,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height,
                color: Colors.blue.shade50,
              ),
            ),
          ),
          SlideTransition(
            position: _animationIconLeft,
            child: Align(
              alignment: Alignment.centerRight,
              child: Image.asset(
                'assets/first.png',
                width: imageSize,
              ),
            ),
          ),
          SlideTransition(
            position: _animationIconRight,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                'assets/second.png',
                width: imageSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
