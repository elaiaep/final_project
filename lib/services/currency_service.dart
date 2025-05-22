import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyService {
  // Using ExchangeRate-API
  static const String apiUrl = 'https://v6.exchangerate-api.com/v6';
  // You need to replace this with your API key from https://www.exchangerate-api.com/
  static const String apiKey = '85e7cc7579d1fc8883ee762d';

  static final List<String> supportedCurrencies = ['USD', 'EUR', 'KZT', 'RUB'];

  static Future<double> convertCurrency(double amount, String from, String to) async {
    final url = '$apiUrl/$apiKey/pair/$from/$to/$amount';
    debugPrint('Making request to: $url');
    
    try {
      final response = await http.get(Uri.parse(url));
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('conversion_result')) {
          return data['conversion_result'] as double;
        } else {
          debugPrint('Unexpected response format: $data');
          return amount;
        }
      } else {
        debugPrint('HTTP Error: ${response.statusCode}');
        debugPrint('Error response: ${response.body}');
        return amount;
      }
    } catch (e) {
      debugPrint('Currency conversion error: $e');
      return amount;
    }
  }
} 