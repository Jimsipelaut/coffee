import 'package:flutter/material.dart';
import 'package:coffeeshop/src/features/home/screens/home_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String paymentMethod;

  const OrderSuccessScreen({super.key, required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    final bool isCod = paymentMethod == 'COD (Cash On Delivery)';

    final String title =
        isCod ? 'Pesanan Dikonfirmasi!' : 'Pembayaran Berhasil!';
    final String subtitle =
        isCod
            ? 'Pesanan Anda akan segera kami siapkan. Mohon siapkan pembayaran tunai saat pengantaran.'
            : 'Pesanan Anda akan segera kami proses. Terima kasih telah berbelanja!';
    final IconData iconData =
        isCod ? Icons.delivery_dining : Icons.check_circle;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                iconData,
                color: isCod ? Colors.blue.shade600 : Colors.green,
                size: 100,
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                const HomeScreen(), // <-- HomeScreen digunakan di sini
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
