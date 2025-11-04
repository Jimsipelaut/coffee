// lib/src/features/cart/providers/cart_provider.dart

import 'package:flutter/foundation.dart';

class CoffeeItem {
  final String name;
  final double price;
  final String imagePath;
  final String selectedSize;
  int quantity;

  CoffeeItem({
    required this.name,
    required this.price,
    required this.imagePath,
    required this.selectedSize,
    required this.quantity,
  });
}

class CartProvider with ChangeNotifier {
  final List<CoffeeItem> _items = [];
  CoffeeItem? _lastAddedItem;

  List<CoffeeItem> get items => _items;

  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      total += item.price * item.quantity;
    }
    return total;
  }

  void addItem(CoffeeItem coffee) {
    final index = _items.indexWhere((item) =>
        item.name == coffee.name && item.selectedSize == coffee.selectedSize);

    if (index != -1) {
      _items[index].quantity += coffee.quantity;
    } else {
      _items.add(coffee);
    }
    _lastAddedItem = coffee;
    notifyListeners();
  }

  // --- FUNGSI BARU UNTUK EDIT KERANJANG ---

  void incrementItemQuantity(int index) {
    if (index >= 0 && index < _items.length) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementItemQuantity(int index) {
    if (index >= 0 && index < _items.length) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeItemByIndex(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }
  
  void undoAddItem() {
    if (_lastAddedItem != null) {
      final index = _items.indexWhere((item) =>
          item.name == _lastAddedItem!.name &&
          item.selectedSize == _lastAddedItem!.selectedSize);

      if (index != -1) {
        if (_items[index].quantity > _lastAddedItem!.quantity) {
          _items[index].quantity -= _lastAddedItem!.quantity;
        } else {
          _items.removeAt(index);
        }
      }
      _lastAddedItem = null;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _lastAddedItem = null;
    notifyListeners();
  }
}