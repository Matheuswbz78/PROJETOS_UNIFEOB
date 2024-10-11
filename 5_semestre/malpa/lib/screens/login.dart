
import 'package:Malpa/styles/style_perfil.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:Malpa/data/secure_storage.dart'; // Certifique-se de que o caminho está correto
import 'package:Malpa/widgets/alertalogin.dart'; // Seu widget de alerta// Seu estilo de texto
import 'package:Malpa/data/envioip.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginUser(String email, String password) async {
    var url = Uri.parse('http://${EnvioIP.apiIP}:3000/api/users/login');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      print('Login bem-sucedido: ${response.body}');
      var data = jsonDecode(response.body);
      // Salvar o token usando SecureStorage
      await SecureStorage.saveToken(data['token']);
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      print(
          'Erro no login: Status ${response.statusCode}, Body: ${response.body}');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Erro de Login"),
          content: Text("Algo está errado, tente novamente"),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Image.asset(
            'assets/fundos/bde.png',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 0.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Image.asset(
                        'assets/logomalpa.png',
                        height: 32.0,
                        width: 32.0,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 180.0),
                      child: Text(
                        "Olá,",
                        style: TextStyle(
                          color: Color(0xFFE1EDFA),
                          fontSize: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.text, // Tipo de teclado para entrada de texto
  style: TextStyle(
    color: Color(0xFFE1EDFA), // Cor do texto
  ),
  decoration: InputDecoration(
    labelText: 'Email', // Rótulo do campo// Texto de dica
    border: AppBorders.inputBorder, // Borda do campo
    filled: true, // Preenchimento ativado
    fillColor: Colors.transparent, // Cor de preenchimento transparente
    focusedBorder: AppBorders.focusedBorder, // Borda quando o campo está em foco
    enabledBorder: AppBorders.enabledBorder, // Borda quando o campo não está em foco
    contentPadding: AppPadding.inputPadding, // Preenchimento interno do conteúdo
    labelStyle: TextStyle(color: AppColors.primaryColor), // Estilo do rótulo
    hintStyle: TextStyle(color: AppColors.primaryColor), // Estilo do texto de dica
    focusColor: AppColors.focusedBorderColor, // Cor de foco
    hoverColor: Colors.transparent, // Evita a mudança de cor quando o mouse está sobre o campo
  ),
),
                    const SizedBox(height: 16),
TextField(
  controller: passwordController,
  keyboardType: TextInputType.visiblePassword, // Tipo de teclado para entrada de texto
  style: TextStyle(
    color: Color(0xFFE1EDFA), // Cor do texto
  ),
  decoration: InputDecoration(
    labelText: 'Senha', // Rótulo do campo// Texto de dica
    border: AppBorders.inputBorder, // Borda do campo
    filled: true, // Preenchimento ativado
    fillColor: Colors.transparent, // Cor de preenchimento transparente
    focusedBorder: AppBorders.focusedBorder, // Borda quando o campo está em foco
    enabledBorder: AppBorders.enabledBorder, // Borda quando o campo não está em foco
    contentPadding: AppPadding.inputPadding, // Preenchimento interno do conteúdo
    labelStyle: TextStyle(color: AppColors.primaryColor), // Estilo do rótulo
    hintStyle: TextStyle(color: AppColors.primaryColor), // Estilo do texto de dica
    focusColor: AppColors.focusedBorderColor, // Cor de foco
    hoverColor: Colors.transparent, // Evita a mudança de cor quando o mouse está sobre o campo
  ),
),

                    SizedBox(
  height: 20,
),
ElevatedButton(
  onPressed: () {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      loginUser(
          emailController.text, passwordController.text);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialogWidget(
          message: "Preencha todos os campos",
        ),
      );
    }
  },
  style: ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
      EdgeInsets.symmetric(vertical: 10.0),
    ),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0), // Borda arredondada
      ),
    ),
    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFE9FE78)), // Cor de fundo do botão
  ),
  child: Text(
    "Entrar",
    style: TextStyle(
      color: Color(0xFF06203B), // Cor do texto
      fontSize: 20, // Tamanho da fonte
    ),
  ),
),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Não tem uma conta? ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight:FontWeight.w400,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/cadastro');
                          },
                          child: Text(
                            "Cadastre-se",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            fontWeight:FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
