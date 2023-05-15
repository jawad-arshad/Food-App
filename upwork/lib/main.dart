
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:FoodApp/providers/cart_provider.dart';
import 'package:FoodApp/view/cart_screen.dart';

void main() async {

  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (context) => CartProvider())],
    child: const FoodApp(),
  ));
}

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cart',
      home: HomePage(),
    );
  }
}
