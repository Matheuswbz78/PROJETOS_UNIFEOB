import 'package:Malpa/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:Malpa/screens/chat.dart';
import 'package:Malpa/screens/map.dart';
import 'package:Malpa/screens/cupons.dart';
import 'package:Malpa/screens/perfil.dart';
import 'package:Malpa/widgets/bottom_navigation.dart';
import 'package:Malpa/data/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'dart:async';
import 'package:Malpa/data/envioip.dart';
import 'package:iconify_flutter_plus/icons/fa6_solid.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;

  Map<String, dynamic> userData = {};
  List<FlSpot> _graphData = [];
  List<String> _historyData = [];
  List<String> _quantidadeData = [];
  List<String> _dateData = [];

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _pointController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchUserPoints();
    _fetchUserHistory();

    Timer.periodic(Duration(seconds: 5), (timer) {
      _fetchUserData();
      _fetchUserPoints();
      _fetchUserHistory();
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _pointController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) {
        throw Exception('Token not found. User might not be logged in.');
      }

      final response = await http.get(
        Uri.parse('http://${EnvioIP.apiIP}:3000/api/users/perfil'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        userData = json.decode(response.body);
        setState(() {
          _nomeController.text = userData['nome'] ?? '';
        });
        print('Dados do usuário atualizados');
      } else {
        throw Exception('Falha ao carregar dados do usuário');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _fetchUserPoints() async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) {
        throw Exception('Token not found. User might not be logged in.');
      }

      final response = await http.get(
        Uri.parse('http://${EnvioIP.apiIP}:3000/api/pontuacao/pontuacao?='),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _pointController.text =
              responseData['pontuacao_atual']?.toString() ?? '0';
          List<dynamic> graphData = responseData['grafico'] ?? [];
          _graphData = graphData
              .map((point) => FlSpot(
                  point['x'].toDouble(), point['pontuacao_atual'].toDouble()))
              .toList();
        });
        print('Dados de pontuação atualizados');
      } else {
        throw Exception('Failed to load user points');
      }
    } catch (e) {
      print('Error fetching user points: $e');
    }
  }

  Future<void> _fetchUserHistory() async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) {
        throw Exception('Token not found. User might not be logged in.');
      }

      final response = await http.get(
        Uri.parse('http://${EnvioIP.apiIP}:3000/api/historico/historico'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _historyData = (responseData as List)
              .map((item) => item['tipo'].toString())
              .toList()
              .take(5)
              .toList();
          _quantidadeData = (responseData)
              .map((item) => item['quantidade'].toString())
              .toList()
              .take(5)
              .toList();
          _dateData = (responseData)
              .map((item) => item['timestamp'].toString())
              .toList()
              .take(5)
              .toList();
        });

        print('Dados de historico atualizados');
        print('Dados do histórico: $_historyData');
      } else {
        throw Exception('Failed to load user history');
      }
    } catch (e) {
      print('Error fetching user history: $e');
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'malpa',
          style: TextStyle(
            color: Color.fromRGBO(6, 32, 59, 1),
            fontSize: 35.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Iconify(Fa6Solid.right_to_bracket),
          color: Color.fromRGBO(182, 210, 29, 1),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/fundos/appbar.png"),
              fit: BoxFit.cover,
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      body: _buildPage(_currentPageIndex),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: _onPageChanged,
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Color.fromRGBO(182, 210, 29, 1),
                        size: 30.0,
                      ),
                      SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pontuações e recompensas de:',
                            style: TextStyle(
                              fontSize: 13.0,
                              color: const Color.fromARGB(255, 30, 30, 30),
                            ),
                          ),
                          Text(
                            _nomeController.text,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 30, 30, 30),
                            ),
                          ),
                          SizedBox(height: 8.0),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${_pointController.text}',
                                style: TextStyle(
                                  color: Color.fromRGBO(6, 32, 59, 1),
                                  fontSize: 50.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'pontos',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 30, 30, 30),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: 100.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Color.fromRGBO(6, 32, 59, 1)),
                          borderRadius: BorderRadius.circular(13.0),
                        ),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: 'ANUAL',
                          elevation: 16,
                          style: TextStyle(
                            color: Color.fromRGBO(6, 32, 59, 1),
                            fontSize: 10.0,
                          ),
                          dropdownColor: Colors.white,
                          underline: Container(
                            height: 0,
                          ),
                          onChanged: (String? newValue) {},
                          items: ['ANUAL']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  value,
                                  style: TextStyle(
                                    color: Color.fromRGBO(6, 32, 59, 1),
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.0),
                Padding(
                  padding: const EdgeInsets.only(left: 35.0, bottom: 10.0),
                  child: Text(
                    'Histórico de Pontuação',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 30, 30, 30),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: Container(
                    height: 200.0,
                    child: _graphData.isEmpty
                        ? Center(
                            child:
                                Text('Nenhum dado disponível para o gráfico'))
                        : LineChart(
                            LineChartData(
                              lineBarsData: [
                                LineChartBarData(
                                  spots: _graphData,
                                  isCurved: false,
                                  colors: [Color.fromRGBO(6, 32, 59, 1)],
                                  barWidth: 8,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, barData, index) {
                                      return FlDotCirclePainter(
                                        radius: 4,
                                        color: Color.fromRGBO(6, 32, 59, 1),
                                        strokeWidth: 3,
                                        strokeColor:
                                            Color.fromRGBO(6, 32, 59, 1),
                                      );
                                    },
                                  ),
                                  belowBarData: BarAreaData(show: false),
                                ),
                              ],
                              titlesData: FlTitlesData(
                                leftTitles: SideTitles(showTitles: false),
                                bottomTitles: SideTitles(
                                  showTitles: true,
                                  getTitles: (value) {
                                    int intValue = value.toInt();
                                    List<String> monthAbbreviations = [
                                      'Nothing',
                                      'Jan',
                                      'Fev',
                                      'Mar',
                                      'Abr',
                                      'Mai',
                                      'Jun',
                                      'Jul',
                                      'Ago',
                                      'Set',
                                      'Out',
                                      'Nov',
                                      'Dez'
                                    ];
                                    if (intValue >= 0 &&
                                        intValue < monthAbbreviations.length) {
                                      return monthAbbreviations[intValue];
                                    } else {
                                      return '';
                                    }
                                  },
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(
                                    color: Color.fromRGBO(116, 134, 154, 1),
                                    width: 2),
                              ),
                              gridData: FlGridData(show: false),
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 35.0, bottom: 7.0),
                  child: Text(
                    'Histórico de Doações',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 30, 30, 30),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: 30.0, right: 30.0, bottom: 30.0, top: 0.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _historyData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Color.fromRGBO(6, 32, 59, 1)),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: ListTile(
                          title: Text(
                            _historyData[index],
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(6, 32, 59, 1),
                            ),
                          ),
                          subtitle: Text(_dateData[index]),
                          trailing: Text('${_quantidadeData[index]} un'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
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
