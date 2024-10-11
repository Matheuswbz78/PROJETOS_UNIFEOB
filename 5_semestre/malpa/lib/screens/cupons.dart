import 'package:Malpa/data/envioip.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cupons.dart';
import '../repositories/cupom_repository.dart';
import 'package:Malpa/data/secure_storage.dart';

class CuponsPage extends StatelessWidget {
  const CuponsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'malpa',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: ThemeData.light().textTheme,
      ),
      home: const MyHomePage(title: 'malpa'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Cupom? _selectedCupom;
  int pontos = 600;
  TextEditingController _pointController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserPoints();
  }

  Future<void> _fetchUserPoints() async {
    try {
      final token = await SecureStorage.getToken();
      if (token == null) {
        throw Exception('Token not found. User might not be logged in.');
      }

      final response = await http.get(
        Uri.parse('http://${EnvioIP.apiIP}:3000/api/pontuacao/pontuacao'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var userData = json.decode(response.body);
        setState(() {
          _pointController.text = userData['pontuacao_atual'].toString();
          pontos = int.parse(userData['pontuacao_atual']
              .toString()); // Assume that 'pontuacao_atual' is an integer.
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabela = CupomRepository.tabela;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fundos/bde.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(247, 247, 247, 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  'Pontos: ${_pointController.text}', // Exibir a pontuação diretamente
                  style: TextStyle(
                    color: Color.fromRGBO(6, 32, 59, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: tabela.length,
                        padding: EdgeInsets.all(20),
                        separatorBuilder: (context, index) => Divider(
                          color: Color.fromRGBO(89, 103, 52, 1),
                        ),
                        itemBuilder: (BuildContext context, int cupomIndex) {
                          final cupom = tabela[cupomIndex];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCupom =
                                    _selectedCupom == cupom ? null : cupom;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          leading: Image.asset(cupom.icone),
                                          title: Text(cupom.nome,
                                              style: TextStyle(fontSize: 20)),
                                          trailing: Text('${cupom.preco}\nPts',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (pontos >= cupom.preco) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Código de Resgate'),
                                                    content: Text(
                                                        'Seu código de resgate é ABC123',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.green)),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('OK'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Pontos Insuficientes',
                                                        style: TextStyle(
                                                            color: Colors.red)),
                                                    content: Text(
                                                        'Você não tem pontos suficientes para resgatar este cupom.',
                                                        style: TextStyle(
                                                            color: Colors.red)),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('OK'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Color.fromRGBO(
                                                        225, 237, 250, 1)),
                                            foregroundColor:
                                                MaterialStateProperty.all(
                                                    Color.fromRGBO(0, 0, 0, 1)),
                                          ),
                                          child: Text('Resgatar'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    height: _selectedCupom == cupom ? 100 : 0,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10),
                                          Text('Mais informações:',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 2),
                                          Text('Descrição: ${cupom.descricao}',
                                              style: TextStyle(fontSize: 14)),
                                          Text('Validade: ${cupom.validade}',
                                              style: TextStyle(fontSize: 14)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
