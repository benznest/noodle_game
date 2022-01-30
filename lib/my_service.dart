import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dao/owlbot_info_response.dart';

class MyService {
  static const String _token = "Token  03ecd3560ff6682ea7d0c349c5aefed994d45362";

  static Future<OwlbotInfoResponseDao?> getDefinition(String word) async {
    var url = Uri.parse('https://owlbot.info/api/v4/dictionary/$word');
    var response = await http.get(url, headers: {
      "Authorization": _token
    });

    Map<String, dynamic>? map = jsonDecode(response.body);
    if (map != null) {
      return OwlbotInfoResponseDao.fromJson(map);
    }
  }
}
