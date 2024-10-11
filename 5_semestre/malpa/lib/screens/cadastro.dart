import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:Malpa/data/envioip.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({Key? key}) : super(key: key);

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _addressNumberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();

  bool _showPassword = false;

  Future<void> _submitCadastro() async {
    var url = Uri.parse('http://${EnvioIP.apiIP}:3000/api/users/register');
    Map<String, dynamic> userData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'address': _addressController.text,
      'addressNumber': _addressNumberController.text,
      'city': _cityController.text,
      'zipCode': _zipCodeController.text,
      'neighborhood': _neighborhoodController.text,
    };

    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201) {
        _showDialog('Cadastro Concluído', 'Cadastro realizado com sucesso!', true);
      } else {
        _showDialog('Erro de Cadastro', 'Falha ao cadastrar: ${response.body}', false);
      }
    } catch (e) {
      print('Erro durante o cadastro: $e');
      _showDialog('Erro de Cadastro', 'Erro durante o cadastro: $e', false);
    }
  }

  void _showDialog(String title, String message, bool successful) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                if (successful) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/fundos/fundoperfil.png'),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 80.0, 20.0, 0.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
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
                margin: const EdgeInsets.only(top: 42.0, bottom: 24.0),
                child: Text(
    'Cadastro',
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 20.0,
      color: Color(0xFFE1EDFA),
    ),
                ),
              ),
              _buildTextField(_nameController, 'Nome', Icons.person),
              SizedBox(height: 16),
              _buildTextField(_emailController, 'Email', Icons.email),
              SizedBox(height: 16),
              _buildPasswordField(),
              SizedBox(height: 16),
              _buildTextField(_addressController, 'Endereço', Icons.location_on),
              SizedBox(height: 16),
              _buildTextField(_addressNumberController, 'Número do Endereço', Icons.format_list_numbered),
              SizedBox(height: 16),
              _buildTextField(_neighborhoodController, 'Bairro', Icons.location_city),
              SizedBox(height: 16),
              _buildTextField(_cityController, 'Cidade', Icons.location_city),
              SizedBox(height: 16),
              _buildTextField(_zipCodeController, 'CEP', Icons.location_pin),
              SizedBox(height: 16),
              _buildSubmitButton(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
  // Crie um FocusNode para o campo de texto
  FocusNode focusNode = FocusNode();

  return TextField(
    controller: controller,
    focusNode: focusNode, // Associe o FocusNode ao campo de texto
    decoration: InputDecoration(
      labelText: label,
      hintText: 'Digite seu $label',
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 8.0),
        child: Icon(icon, color: Color.fromARGB(180, 242, 247, 253)),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(60.0),
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(60.0),
        borderSide: BorderSide(color: Colors.white),
      ),
      // Defina a borda quando o campo está em foco
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(60.0),
        borderSide: BorderSide(color: Color(0xFFE9FE78)), // Altere para a cor rosa quando em foco
      ),
      contentPadding: EdgeInsets.all(14.0),
      labelStyle: TextStyle(color: Color.fromARGB(255, 253, 238, 238)),
      hintStyle: TextStyle(color: Color.fromARGB(255, 253, 238, 238)),
      focusColor: Color(0xFFE9FE78),
      filled: true,
      fillColor: Colors.transparent,
    ),
    style: TextStyle(color: Color.fromARGB(255, 253, 238, 238)),
  );
}


  Widget _buildPasswordField() {
  return TextField(
    controller: _passwordController,
    decoration: InputDecoration(
      labelText: 'Senha',
      hintText: 'Digite sua senha',
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 8.0), // Adicionando padding à esquerda e à direita
        child: Icon(Icons.lock, color: Color.fromARGB(180, 242, 247, 253)),
      ),
      suffixIcon: IconButton(
        icon: Padding(
          padding: EdgeInsets.only(left: 8.0, right: 16.0), // Padding de 8px à esquerda e 16px à direita
          child: Icon(_showPassword ? Icons.visibility : Icons.visibility_off, color: Color.fromARGB(180, 242, 247, 253)),
        ),
        onPressed: () {
          setState(() {
            _showPassword = !_showPassword;
          });
        },
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(60.0),
        borderSide: BorderSide(color: Colors.white), // Alterando a cor da borda para branca
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(60.0),
        borderSide: BorderSide(color: Colors.white), // Alterando a cor da borda para branca
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(60.0),
        borderSide: BorderSide(color: Color(0xFFE9FE78)),
      ),
      contentPadding: EdgeInsets.all(14.0),
      labelStyle: TextStyle(color: Color.fromARGB(255, 253, 238, 238)),
      hintStyle: TextStyle(color: Color.fromARGB(255, 253, 238, 238)),
      focusColor: Color(0xFFE9FE78),
      filled: true,
      fillColor: Colors.transparent,
    ),
    obscureText: !_showPassword,
    style: TextStyle(color: Color.fromARGB(255, 253, 238, 238)),
  );
}



Widget _buildSubmitButton() {
  return Container(
    margin: EdgeInsets.only(top: 8.0), // Adicionando margem inferior de 40 pixels
    child: ElevatedButton(
      onPressed: _submitCadastro,
      child: Text(
        'Cadastrar',
        style: TextStyle(
          color: Color(0xFF06203B),
          fontSize: 20, // Adicionando negrito ao texto
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFE9FE78),
        padding: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    ),
  );
}

}
