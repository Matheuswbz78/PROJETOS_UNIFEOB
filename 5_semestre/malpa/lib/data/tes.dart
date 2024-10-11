// Em qualquer lugar após importar seus pacotes e a classe SecureStorage
import 'package:http/http.dart' as http;
import 'secure_storage.dart'; // Importe sua classe SecureStorage

void makeAuthenticatedRequest() async {
  String? token = await SecureStorage.getToken();
  var response = await http.get(
    Uri.parse('https://yourapi.com/protected-route'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );
  print("Response status: ${response.statusCode}");
  print("Response body: ${response.body}");
}
