import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/cart_screen.dart';

void main() {
  runApp(const NovaStoreApp());
}

class NovaStoreApp extends StatelessWidget {
  const NovaStoreApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NovaStore Mini Katalog',
      debugShowCheckedModeBanner: false,
      // Yönergedeki "Route" mantığını burada tanımlıyoruz
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/detail': (context) => const DetailScreen(), // Route Arguments ile veri alacak sayfamız
        '/cart': (context) => const CartScreen(),
      },
    );
  }
}