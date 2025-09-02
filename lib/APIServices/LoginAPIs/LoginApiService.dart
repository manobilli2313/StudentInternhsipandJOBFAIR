
import 'package:http/http.dart' as http;
class LoginApi{



  static String baseurl = 'http://192.168.0.170/SIJBAPI/api/Login/';

   // Login API
 

Future<http.Response> login(String username, String password) async {
  String url = '${baseurl}loginuser?Username=$username&password=$password'; // Corrected URL
  
  final response = await http.get(Uri.parse(url));

  return response;  // Return the full HTTP response
}

}