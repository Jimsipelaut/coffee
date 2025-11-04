// lib/src/features/home/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffeeshop/src/features/auth/screen/login_screen.dart';
import 'package:coffeeshop/src/features/cart/providers/cart_provider.dart';
import 'package:coffeeshop/src/features/home/widgets/coffee_card.dart';
import 'package:coffeeshop/src/features/product_detail/screens/detail_screen.dart';
import 'package:coffeeshop/src/features/payments/screens/payment_screen.dart';
import 'package:coffeeshop/src/features/auth/screen/providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _allCoffees = [
    {'name': 'Cappuccino', 'prices': {'S': 23000.0, 'M': 25000.0, 'L': 28000.0}, 'image': 'assets/images/cappuccino.jpg', 'description': 'Perpaduan seimbang antara espresso, susu panas, dan busa susu lembut.'},
    {'name': 'Latte', 'prices': {'S': 26000.0, 'M': 28000.0, 'L': 31000.0}, 'image': 'assets/images/latte.jpg', 'description': 'Kopi lembut dengan lebih banyak porsi susu panas dan lapisan tipis busa.'},
    {'name': 'Espresso', 'prices': {'S': 18000.0, 'M': 18000.0, 'L': 18000.0}, 'image': 'assets/images/espresso.jpg', 'description': 'Ekstrak kopi murni yang pekat dan kaya rasa.'},
    {'name': 'Mocha', 'prices': {'S': 24000.0, 'M': 32000.0, 'L': 40000.0}, 'image': 'assets/images/mocha.jpg', 'description': 'Campuran mewah antara espresso, cokelat panas, dan susu.'},
    {'name': 'Americano', 'prices': {'S': 20000.0, 'M': 22000.0, 'L': 24000.0}, 'image': 'assets/images/espresso.jpg', 'description': 'Espresso yang diencerkan dengan air panas, menciptakan kopi hitam yang kuat.'},
    {'name': 'Macchiato', 'prices': {'S': 24000.0, 'M': 26000.0, 'L': 29000.0}, 'image': 'assets/images/latte.jpg', 'description': 'Satu shot espresso dengan sedikit noda busa susu di atasnya.'},
  ];

  late List<Map<String, dynamic>> _filteredCoffees;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCoffees = _allCoffees;
    _searchController.addListener(_filterCoffees);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCoffees);
    _searchController.dispose();
    super.dispose();
  }

  void _filterCoffees() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCoffees = _allCoffees.where((coffee) {
        final coffeeName = (coffee['name'] as String).toLowerCase();
        return coffeeName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final userEmail = userProvider.userEmail ?? 'Guest';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.white70),
          tooltip: 'Logout',
          onPressed: () {
            Provider.of<CartProvider>(context, listen: false).clearCart();
            Provider.of<UserProvider>(context, listen: false).logout();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false);
          },
        ),
        title: Text(
          'Hi, ${userEmail.split('@')[0]}',
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart,
                    color: Colors.white70, size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PaymentScreen()),
                  );
                },
              ),
              if (cart.items.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      cart.items.length.toString(),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Find your coffee..',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xFF141921),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 25),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: 0.75,
                ),
                itemCount: _filteredCoffees.length,
                itemBuilder: (context, index) {
                  final coffee = _filteredCoffees[index];
                  final prices = coffee['prices'] as Map<String, double>;
                  return CoffeeCard(
                    name: coffee['name'] as String,
                    price: prices['M']!,
                    imagePath: coffee['image'] as String,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(
                            coffeeName: coffee['name'] as String,
                            coffeePrices: prices,
                            coffeeDescription: coffee['description'] as String,
                            imagePath: coffee['image'] as String,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20), // Memberi sedikit padding di bawah
            ],
          ),
        ),
      ),
    );
  }
}