import 'package:flutter/material.dart';
import 'package:Malpa/screens/home.dart';
import 'package:Malpa/screens/map.dart';
import 'package:Malpa/screens/chat.dart';
import 'package:Malpa/screens/cupons.dart';
import 'package:Malpa/screens/perfil.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ion.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:iconify_flutter_plus/icons/ph.dart';
import 'package:iconify_flutter_plus/icons/ri.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/home': (context) => HomePage(),
        '/map': (context) => MapPage(),
        '/chat': (context) => ChatPage(),
        '/coupons': (context) => CuponsPage(),
        '/perfil': (context) => PerfilPage(),
      },
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bottom Navigation Demo'),
      ),
      body: Center(
        child: _getPage(_currentIndex),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return MapPage();
      case 2:
        return ChatPage();
      case 3:
        return CuponsPage();
      case 4:
        return PerfilPage();
      default:
        return Container();
    }
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Iconify(MaterialSymbols.home_rounded, color: Color.fromRGBO(156, 156, 156,1)),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Iconify(Ph.map_pin_fill, color: Color.fromRGBO(156, 156, 156,1)),
          label: 'Mapa',
        ),
        BottomNavigationBarItem(
          icon: Iconify(Ion.chatboxes, color: Color.fromRGBO(156, 156, 156,1)),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Iconify(Mdi.ticket_percent, color: Color.fromRGBO(156, 156, 156,1)),
          label: 'Cupons',
        ),
        BottomNavigationBarItem(
          icon: Iconify(Ri.user_3_fill, color: Color.fromRGBO(156, 156, 156,1), ),
          label: 'Perfil',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Color.fromRGBO(182, 210, 29, 1),
      unselectedItemColor: Color.fromRGBO(6, 32, 59,1),
      onTap: onTap,
    );
  }
}

void main() {
  runApp(MyApp());
}
