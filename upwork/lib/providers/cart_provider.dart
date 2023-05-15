import 'package:flutter/material.dart';

import '../models/base_model.dart';

class CartProvider with ChangeNotifier {
  List<FoodItemModel> foodItemList = [
    FoodItemModel(name: 'Biryani', price: 300, freeFood: "Salad"),
    FoodItemModel(name: 'Nehari', price: 200),
    FoodItemModel(name: 'Naan Chany', price: 250),
    FoodItemModel(name: 'Salad', price: 150),
  ];
  List<CartCellModel> items = [];
  double totalPrice = 0;
  CouponModel appliedCouponModel = CouponModel();

  void addItem(FoodItemModel foodItemModel) {
    items.add(CartCellModel(foodItemModel: foodItemModel));
    totalPrice += foodItemModel.price;
    if (foodItemModel.freeFood.isNotEmpty) {
      items.add(CartCellModel(foodItemModel: _checkFreeItem(foodItemModel)));
    }
    notifyListeners();
  }

  void removeItem(CartCellModel item) {
    items.remove(item);
    if(item.foodItemModel.name == "Salad"){
      items.remove(item);
      notifyListeners();
      return;
    }
    totalPrice -= item.foodItemModel.price;
      if (appliedCouponModel != null) {
      if (appliedCouponModel.level == 1) {
        totalPrice = calculateDiscountedPrice(totalPrice, 10);
      } else if (appliedCouponModel.level == 2) {
        totalPrice = calculateDiscountedPrice(totalPrice, 20);
      }
    }

    if (items.isEmpty) {
      totalPrice = 0;
      appliedCouponModel = CouponModel();
    }

    notifyListeners();
  }

  void applyCoupon(CouponModel couponModel) {
    appliedCouponModel = couponModel;
    if (couponModel.level == 1) {
      totalPrice -= totalPrice * 0.1;
    } else if (couponModel.level == 2) {
      totalPrice -= totalPrice * 0.2;
    }
    notifyListeners();
  }

  FoodItemModel _checkFreeItem(FoodItemModel dish) {
    FoodItemModel freeItem = FoodItemModel();
    if (foodItemList.isNotEmpty) {
      freeItem = foodItemList.firstWhere((item) => item.name == dish.freeFood);
    }

    return freeItem;
  }

   double calculateDiscountedPrice(double price, double discountPercent) {
    double discount = price * (discountPercent / 100);
    return price - discount;
  }
}
