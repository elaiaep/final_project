import 'package:flutter/material.dart';

class Reusable {
  static ElevatedButton elevatedButton({
    required String text,
    required VoidCallback onPressed,
  }) => ElevatedButton(
    onPressed: onPressed,
    child: Text(text),
  );

  static Widget title(String text) => Text(
    text,
    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  );
}