import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:coffeeshop/src/features/cart/providers/cart_provider.dart';
import 'package:coffeeshop/src/features/payments/screens/virtual_account_display_screen.dart';
import 'package:coffeeshop/src/features/payments/screens/order_success_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'Virtual Account (BCA)';
  final TextEditingController _addressController = TextEditingController();

  Future<void> _processPayment(BuildContext context, CartProvider cart) async {
    if (_selectedPaymentMethod.startsWith('Virtual Account')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VirtualAccountDisplayScreen(
            totalAmount: cart.totalPrice,
            paymentMethod: _selectedPaymentMethod,
          ),
        ),
      );
    } else if (_selectedPaymentMethod == 'COD (Cash On Delivery)') {
      if (_addressController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Alamat pengiriman tidak boleh kosong untuk COD.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.of(context).pop(); // Tutup dialog loading
        cart.clearCart();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OrderSuccessScreen(paymentMethod: _selectedPaymentMethod),
          ),
          (route) => false,
        );
      }
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final cart = Provider.of<CartProvider>(context);

    if (cart.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Keranjang Kosong'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(
          child: Text(
            'Keranjang Anda kosong. Silakan pilih kopi favorit Anda!',
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ringkasan Pesanan',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, i) {
                  final item = cart.items[i];
                  return Card(
                    color: const Color(0xFF141921),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              item.imagePath,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item.name} (${item.selectedSize})',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatter.format(item.price),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.remove_circle,
                                  size: 20,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                onPressed: () => cart.decrementItemQuantity(i),
                              ),
                              Text(
                                item.quantity.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.add_circle,
                                  size: 20,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                                onPressed: () => cart.incrementItemQuantity(i),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                  size: 22,
                                ),
                                onPressed: () => cart.removeItemByIndex(i),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 20),
            const Text(
              'Metode Pembayaran',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Card(
              color: const Color(0xFF141921),
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: RadioListTile<String>(
                title: const Text('Virtual Account (BCA)'),
                value: 'Virtual Account (BCA)',
                groupValue: _selectedPaymentMethod,
                onChanged:
                    (value) => setState(() => _selectedPaymentMethod = value!),
                secondary: FaIcon(
                  FontAwesomeIcons.buildingColumns,
                  color: Colors.blue.shade600,
                  size: 30,
                ),
                activeColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Card(
              color: const Color(0xFF141921),
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: RadioListTile<String>(
                title: const Text('COD (Cash On Delivery)'),
                value: 'COD (Cash On Delivery)',
                groupValue: _selectedPaymentMethod,
                onChanged:
                    (value) => setState(() => _selectedPaymentMethod = value!),
                secondary: Icon(
                  Icons.delivery_dining,
                  color: Colors.orange.shade700,
                  size: 36,
                ),
                activeColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
            if (_selectedPaymentMethod == 'COD (Cash On Delivery)')
              Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 4, right: 4),
                child: TextField(
                  controller: _addressController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Masukkan alamat lengkap pengiriman Anda...',
                    labelText: 'Alamat Pengiriman',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E232C),
                  ),
                ),
              ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    formatter.format(cart.totalPrice),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _processPayment(context, cart),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                child: const Text(
                  'Bayar Sekarang',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
