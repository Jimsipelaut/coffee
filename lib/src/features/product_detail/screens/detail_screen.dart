import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:coffeeshop/src/features/cart/providers/cart_provider.dart';
import 'package:coffeeshop/src/features/product_detail/widgets/size_chip.dart';
class DetailScreen extends StatefulWidget {
  final String coffeeName;
  final Map<String, double> coffeePrices;
  final String imagePath;
  final String coffeeDescription;

  const DetailScreen({
    super.key,
    required this.coffeeName,
    required this.coffeePrices,
    required this.imagePath,
    required this.coffeeDescription,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String _selectedSize = 'M';
  late double _currentPrice;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    // Atur harga awal berdasarkan ukuran default 'M'
    _currentPrice = widget.coffeePrices[_selectedSize]!;
  }

  // Fungsi untuk mengubah ukuran dan harga
  void _updateSize(String newSize) {
    setState(() {
      _selectedSize = newSize;
      _currentPrice = widget.coffeePrices[newSize]!;
    });
  }

  // Fungsi untuk menambah kuantitas
  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  // Fungsi untuk mengurangi kuantitas
  void _decrementQuantity() {
    // Kuantitas tidak bisa kurang dari 1
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = Provider.of<CartProvider>(context, listen: false);
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.coffeeName,
            style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Hero(
                tag: widget.imagePath + widget.coffeeName, // Tag Hero unik
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(widget.imagePath, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6, // Flex disesuaikan untuk memberi lebih banyak ruang
            child: Container(
              padding: const EdgeInsets.all(25.0),
              decoration: const BoxDecoration(
                color: Color(0xFF141921),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description',
                      style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    widget.coffeeDescription,
                    style:
                        const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  const Text('Size',
                      style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => _updateSize('S'),
                        child: SizeChip(
                            label: 'S', isSelected: _selectedSize == 'S'),
                      ),
                      GestureDetector(
                        onTap: () => _updateSize('M'),
                        child: SizeChip(
                            label: 'M', isSelected: _selectedSize == 'M'),
                      ),
                      GestureDetector(
                        onTap: () => _updateSize('L'),
                        child: SizeChip(
                            label: 'L', isSelected: _selectedSize == 'L'),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Price',
                              style: TextStyle(color: Colors.white70)),
                          Text(
                            formatter.format(_currentPrice *
                                _quantity), // Tampilkan harga total (harga * kuantitas)
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: _decrementQuantity,
                            icon: Icon(Icons.remove_circle,
                                color: theme.colorScheme.secondary, size: 28),
                          ),
                          Text('$_quantity',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          IconButton(
                            onPressed: _incrementQuantity,
                            icon: Icon(Icons.add_circle,
                                color: theme.colorScheme.secondary, size: 28),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final coffee = CoffeeItem(
                          name: widget.coffeeName,
                          price: _currentPrice,
                          imagePath: widget.imagePath,
                          selectedSize: _selectedSize,
                          quantity: _quantity,
                        );
                        cart.addItem(coffee);

                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                  '${widget.coffeeName} ($_selectedSize) x$_quantity ditambahkan'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                      ),
                      child: const Text('Add to Cart',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}