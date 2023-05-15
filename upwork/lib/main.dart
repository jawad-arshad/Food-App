
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upwork/providers/cart_provider.dart';
import 'package:upwork/view/cart_screen.dart';

void main() async {

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (context) => CartProvider())],
    child: const ChickenPizzaApp(),
  ));
}

class ChickenPizzaApp extends StatelessWidget {
  const ChickenPizzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cart',
      home: HomePage(),
    );
  }
}
