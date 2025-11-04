// lib/src/features/payment/screens/virtual_account_display_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:coffeeshop/src/features/cart/providers/cart_provider.dart';
import 'package:coffeeshop/src/features/payments/screens/order_success_screen.dart';

class VirtualAccountDisplayScreen extends StatefulWidget {
  final double totalAmount;
  final String paymentMethod;

  const VirtualAccountDisplayScreen({
    super.key,
    required this.totalAmount,
    required this.paymentMethod,
  });

  @override
  State<VirtualAccountDisplayScreen> createState() =>
      _VirtualAccountDisplayScreenState();
}

class _VirtualAccountDisplayScreenState
    extends State<VirtualAccountDisplayScreen> {
  bool _isLoading = false;
  bool _isVaCopied = false;
  late String vaNumber;

  @override
  void initState() {
    super.initState();
    final random = Random();
    vaNumber = '8808${100000000 + random.nextInt(900000000)}';
  }

  Future<void> _validateAndProcessPayment() async {
    if (!_isVaCopied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan salin Nomor Virtual Account terlebih dahulu.'),
          backgroundColor: Colors.redAccent,
          // 1. TAMBAHKAN DURASI DI SINI
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    Provider.of<CartProvider>(context, listen: false).clearCart();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              OrderSuccessScreen(paymentMethod: widget.paymentMethod)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Instruksi Pembayaran'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Selesaikan Pembayaran Anda',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
                'Segera lakukan pembayaran sebelum pesanan Anda dibatalkan secara otomatis oleh sistem.',
                style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            Card(
              color: const Color(0xFF141921),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(widget.paymentMethod,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 15),
                    const Text('Nomor Virtual Account',
                        style:
                            TextStyle(fontSize: 16, color: Colors.white70)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(vaNumber,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5)),
                        IconButton(
                          icon: Icon(
                            Icons.copy,
                            size: 20,
                            color: _isVaCopied ? Colors.green : Colors.white70,
                          ),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: vaNumber));
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                    content: Text('Nomor VA disalin!'),
                                    // 2. TAMBAHKAN DURASI DI SINI
                                    duration: Duration(seconds: 1),
                                ),
                              );
                            setState(() {
                              _isVaCopied = true;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text('Total Pembayaran',
                        style:
                            TextStyle(fontSize: 16, color: Colors.white70)),
                    Text(formatter.format(widget.totalAmount),
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.secondary)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isLoading ? null : _validateAndProcessPayment,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                backgroundColor: _isVaCopied
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey.shade800,
                disabledBackgroundColor: Colors.grey.shade700,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Saya Sudah Membayar',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(
                    color: _isLoading
                        ? Colors.grey.shade700
                        : Colors.white54),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
              ),
              child: Text('Batalkan',
                  style: TextStyle(
                      fontSize: 18,
                      color: _isLoading
                          ? Colors.grey.shade700
                          : Colors.white70)),
            )
          ],
        ),
      ),
    );
  }
}