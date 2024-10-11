import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatelessWidget {
  ChatPage();

  @override
  Widget build(BuildContext context) {
    return TestePage();
  }
}

class TestePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MonkAis',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _userInput = TextEditingController();
  static const apiKey =
      "AIzaSyCdnur627w7dXEgwi_vuMvAwgiIa3ayq0k"; // Substitua pela sua chave de API
  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _addInitialMessage();
  }

  void _addInitialMessage() {
    setState(() {
      _messages.add(Message(
        isUser: false,
        message:
            "Olá! Eu sou o MonkAI, um chatbot ambientalista para lhe auxiliar a ajudar o meio ambiente! 🌿",
        date: DateTime.now(),
      ));
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    final message = _userInput.text;

    if (message.isNotEmpty) {
      setState(() {
        _messages
            .add(Message(isUser: true, message: message, date: DateTime.now()));
        _userInput.clear(); // Limpa o campo de texto após enviar a mensagem
      });

      final content =
          _messages.map((msg) => Content.text(msg.message)).toList();
      final response = await model.generateContent(content);

      setState(() {
        _messages.add(Message(
          isUser: false,
          message: response.text ??
              "Desculpe, não entendi sua mensagem. Pode reformular?",
          date: DateTime.now(),
        ));
      });

      // Rolagem automática para a última mensagem
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Color.fromARGB(116, 134, 154, 255).withOpacity(0.8),
              BlendMode.dstATop,
            ),
            image: AssetImage("assets/fundos/fundochat.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Messages(
                    isUser: message.isUser,
                    message: message.message,
                    date: DateFormat('HH:mm').format(message.date),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 15,
                    child: TextFormField(
                      style: const TextStyle(
                        color: Color.fromRGBO(225, 237, 250, 1),
                      ),
                      controller: _userInput,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(
                                247, 247, 247, 1), // Cor da borda padrão
                          ),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(247, 247, 247,
                                1), // Cor da borda quando em foco
                          ),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        labelText: 'Converse com o MonkAI',
                        labelStyle: TextStyle(
                          color: Color.fromRGBO(247, 247, 247, 1),
                        ), // Cor do texto do label
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    padding: const EdgeInsets.all(12),
                    iconSize: 36,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color.fromRGBO(
                          247, 247, 247, 1)), // Usando tom mais escuro de verde
                      foregroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(6, 32, 59, 1),
                      ), // Texto branco para melhor contraste
                      shape: MaterialStateProperty.all(const CircleBorder()),
                    ),
                    onPressed: sendMessage,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({required this.isUser, required this.message, required this.date});
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;

  const Messages(
      {Key? key,
      required this.isUser,
      required this.message,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: isUser
              ? Color.fromARGB(
                  247, 247, 247, 255) // Usando tom mais claro de verde
              : Color.fromARGB(225, 237, 250, 255), // Usando tom médio de verde
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(0, 0, 0, 1), // Cor do texto preto
              ),
            ),
            Text(
              date,
              style: TextStyle(
                fontSize: 15,
                color: isUser
                    ? Colors.grey[600]
                    : Color.fromRGBO(
                        225, 237, 250, 1), // Usando cinza escuro para datas
              ),
            ),
          ],
        ),
      ),
    );
  }
}
