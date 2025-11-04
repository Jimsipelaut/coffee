// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffeeshop/src/core/theme/app_theme.dart';
// FIX 1: Perbaiki path 'screen' menjadi 'screens'
import 'package:coffeeshop/src/features/auth/screen/login_screen.dart'; 
import 'package:coffeeshop/src/features/cart/providers/cart_provider.dart';
// FIX 1: Perbaiki path 'screen' menjadi 'screens' (jika file provider ada di sana)
// Jika Anda membuat folder providers di dalam auth, path ini mungkin perlu disesuaikan.
// Berdasarkan file Anda sebelumnya, ini path yang seharusnya.
import 'package:coffeeshop/src/features/auth/screen/providers/user_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      // FIX 2: Tambahkan properti 'child' di sini untuk menyambungkan provider ke aplikasi
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kopi Hore', // Judul sudah sesuai
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LoginScreen(),
    );
  }
}