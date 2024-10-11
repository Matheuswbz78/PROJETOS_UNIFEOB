import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Malpa/screens/cadastro.dart';
import 'package:Malpa/screens/home.dart';
import 'package:Malpa/screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => HomePage(),
        '/cadastro': (context) => Cadastro(),
      },
      title: 'Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AnimatedSplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({Key? key}) : super(key: key);

  @override
  _AnimatedSplashScreenState createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // Iniciando da esquerda
      end: const Offset(1.0, 0.0), // Indo até a direita
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _timer = Timer(const Duration(milliseconds: 500), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Primeira imagem (fundo de login)
          Image.asset(
            'assets/estrada.png',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          // Segunda imagem (que se move na animação)
          SlideTransition(
            position: _animation,
            child: Center(
              child: Image.asset(
                'assets/logoazul2.gif',
                width: 2500,
                height: 2500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
