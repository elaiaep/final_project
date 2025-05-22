import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class YouTubeService {
  // Replace with your YouTube API key
  static const String apiKey = 'AIzaSyBgpQx9Ln-KL7kKa25lNx8JT1QltBsON_A';
  static const String apiUrl = 'https://www.googleapis.com/youtube/v3';

  static Future<List<Map<String, dynamic>>> searchGuitarVideos(String guitarModel) async {
    try {
      final query = '$guitarModel guitar review demo';
      debugPrint('Searching for videos with query: $query');

      final response = await http.get(
        Uri.parse(
          '$apiUrl/search?part=snippet&q=${Uri.encodeComponent(query)}&type=video&maxResults=5&key=$apiKey'
        ),
      );

      debugPrint('Video Search Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['items'] != null) {
          return List<Map<String, dynamic>>.from(data['items']);
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error searching videos: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> searchGuitarTutorials(String guitarModel) async {
    try {
      final query = '$guitarModel guitar tutorial lesson';
      debugPrint('Searching for tutorials with query: $query');

      final response = await http.get(
        Uri.parse(
          '$apiUrl/search?part=snippet&q=${Uri.encodeComponent(query)}&type=video&maxResults=3&key=$apiKey'
        ),
      );

      debugPrint('Tutorial Search Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['items'] != null) {
          return List<Map<String, dynamic>>.from(data['items']);
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error searching tutorials: $e');
      return [];
    }
  }
} 