import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Malpa/data/secure_storage.dart';
import 'package:Malpa/styles/style_perfil.dart';
import 'package:Malpa/data/envioip.dart';


class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  Map<String, dynamic> userData = {};

  TextEditingController _nomeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _addressNumberController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _zipCodeController = TextEditingController();
  TextEditingController _neighborhoodController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _addressNumberController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    _neighborhoodController.dispose();
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
          _emailController.text = userData['email'] ?? '';
          _addressController.text = userData['endereco'] ?? '';
          _addressNumberController.text = userData['numero_endereco'] ?? '';
          _cityController.text = userData['cidade'] ?? '';
          _zipCodeController.text = userData['cep'] ?? '';
          _neighborhoodController.text = userData['bairro'] ?? '';
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

  Future<void> _updateProfile() async {
    Map<String, dynamic> updatedData = {
      'nome': _nomeController.text,
      'email': _emailController.text,
      'endereco': _addressController.text,
      'numero_endereco': _addressNumberController.text,
      'cidade': _cityController.text,
      'cep': _zipCodeController.text,
      'bairro': _neighborhoodController.text,
    };

    try {
      final token = await SecureStorage.getToken();
      final response = await http.put(
        Uri.parse('http://${EnvioIP.apiIP}:3000/api/users/atualizar-perfil'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dados salvos com sucesso!')),
        );
        _fetchUserData(); // Reload data to ensure consistency
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  InputDecoration getInputDecoration(String label, {String hintText = ''}) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      border: AppBorders.inputBorder,
      filled: true,
      fillColor: Colors.transparent,
      focusedBorder: AppBorders.focusedBorder,
      enabledBorder: AppBorders.enabledBorder,
      contentPadding: AppPadding.inputPadding,
      labelStyle: TextStyle(color: AppColors.primaryColor),
      hintStyle: TextStyle(color: AppColors.primaryColor),
      focusColor: AppColors.focusedBorderColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/fundos/fundoperfil.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    'Editar Perfil',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFFE1EDFA),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60.0,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            AssetImage('assets/logoazul.gif'),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 4.0),
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(182, 210, 29, 1),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _nomeController,
                  style: TextStyle(color: Color(0xFFE1EDFA)),
                  decoration:
                      getInputDecoration('Nome', hintText: 'Digite seu nome'),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: _emailController,
                  style: TextStyle(color: Color(0xFFE1EDFA)),
                  decoration: getInputDecoration('E-mail',
                      hintText: 'Digite seu e-mail'),
                ),
                SizedBox(height: 8.0),
            
                SizedBox(height: 8.0),
                TextField(
                  controller: _addressController,
                  style: TextStyle(color: Color(0xFFE1EDFA)),
                  decoration: getInputDecoration('Endereço',
                      hintText: 'Digite seu endereço'),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: _addressNumberController,
                  style: TextStyle(color: Color(0xFFE1EDFA)),
                  decoration:
                      getInputDecoration('Número', hintText: 'Digite o número'),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: _cityController,
                  style: TextStyle(color: Color(0xFFE1EDFA)),
                  decoration:
                      getInputDecoration('Cidade', hintText: 'Digite a cidade'),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: _zipCodeController,
                  style: TextStyle(color: Color(0xFFE1EDFA)),
                  decoration:
                      getInputDecoration('CEP', hintText: 'Digite o CEP'),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: _neighborhoodController,
                  style: TextStyle(color: Color(0xFFE1EDFA)),
                  decoration:
                      getInputDecoration('Bairro', hintText: 'Digite o bairro'),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 14.0),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color.fromRGBO(182, 210, 29, 1)),
                    ),
                    child: SizedBox(
                      width: double.infinity, // Make the button full width
                      child: Center(
                        child: Text(
                          'Salvar',
                          style: TextStyle(color: Color(0xFF06203B)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
