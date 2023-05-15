import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/base_model.dart';
import '../providers/cart_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Menu'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CartSummary()));
            },
            child: Stack(
              children: [
                const Icon(
                  Icons.shopping_cart,
                  size: 30,
                ),
                Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                    child: Text("${Provider.of<CartProvider>(context).items.length}")),
              ],
            ),
          )
        ],
      ),
      body: const FoodItemList(),
    );
  }
}

class FoodItemList extends StatelessWidget {
  const FoodItemList({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return ListView.builder(
      itemCount: cartProvider.foodItemList.length,
      itemBuilder: (context, index) {
        final dish = cartProvider.foodItemList[index];
        return ListTile(
          title: Text(dish.name),
          subtitle: Text('Price: Rs${dish.price}'),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false).addItem(dish);
            },
          ),
        );
      },
    );
  }
}

class CartSummary extends StatelessWidget {
  const CartSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Cart Summary',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: cartProvider.items.length,
              itemBuilder: (context, index) {
                final item = cartProvider.items[index];
                return ListTile(
                  title: Text(item.foodItemModel.name),
                  subtitle: Text('Price: Rs${item.foodItemModel.price}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false).removeItem(item);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 10.0),
            cartProvider.appliedCouponModel.level == 1
                ? const Text('Coupon Per: 10%')
                : cartProvider.appliedCouponModel.level == 2
                    ? const Text('Coupon Per: 20%')
                    : const Text("Coupon Per: 0%"),
            Text('Total: Rs${cartProvider.totalPrice.toStringAsFixed(1)}'),
            const SizedBox(height: 10.0),
            const CouponButton(),
          ],
        ),
      ),
    );
  }
}

class CouponButton extends StatelessWidget {
  const CouponButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Column(
      children: [
        const Text(
          'Apply Coupon',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5.0),
        ElevatedButton(
          onPressed: cartProvider.couponApplied
              ? () {
              }
              : cartProvider.totalPrice >= 1000
                  ? () {
                      cartProvider.applyCoupon(CouponModel(level: 2, discount: 20));
                    }
                  : cartProvider.totalPrice >= 500
                      ? () {
                          cartProvider.applyCoupon(CouponModel(level: 1, discount: 10));
                        }
                      : null,
          child: const Text('Apply Coupon'),
        ),
      ],
    );
  }
}
