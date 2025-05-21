import 'package:flutter/foundation.dart';
import 'guitar.dart';

class CartItem {
  final Guitar guitar;
  int quantity;

  CartItem({
    required this.guitar,
    this.quantity = 1,
  });

  double get total => guitar.price * quantity;
}

class Cart extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, item) {
      total += item.total;
    });
    return total;
  }

  void addItem(Guitar guitar) {
    if (_items.containsKey(guitar.name)) {
      _items.update(
        guitar.name,
        (existingItem) => CartItem(
          guitar: existingItem.guitar,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        guitar.name,
        () => CartItem(guitar: guitar),
      );
    }
    notifyListeners();
  }

  void removeItem(String guitarName) {
    _items.remove(guitarName);
    notifyListeners();
  }

  void updateQuantity(String guitarName, int quantity) {
    if (_items.containsKey(guitarName)) {
      if (quantity > 0) {
        _items.update(
          guitarName,
          (existingItem) => CartItem(
            guitar: existingItem.guitar,
            quantity: quantity,
          ),
        );
      } else {
        _items.remove(guitarName);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
} 