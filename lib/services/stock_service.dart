// stock_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class StockService {
  static const _apiKey = 'd0lq749r01qpni30nkagd0lq749r01qpni30nkb0';
  static const _baseUrl = 'https://finnhub.io/api/v1';

  static Future<double> getLivePrice(String symbol) async {
    try {
      final formattedSymbol = symbol.endsWith('.NS') || symbol.endsWith('.BO')
          ? symbol
          : '${symbol.toUpperCase()}.NS';

      final url = '$_baseUrl/quote?symbol=$formattedSymbol&token=$_apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['c'] as num).toDouble(); // 'c' = current price
      } else {
        throw Exception('Failed to fetch price');
      }
    } catch (e) {
      print("API error: $e");
      return 0.0;
    }
  }
}
