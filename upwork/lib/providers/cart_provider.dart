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
    couponValue = 0.0;
    if (appliedCouponModel.level == 1 && totalPrice >= 500) {
      totalPrice += foodItemModel.price;
      if (foodItemModel.freeFood.isNotEmpty) {
        items.add(CartCellModel(foodItemModel: _checkFreeItem(foodItemModel)));
      }
    } else if (appliedCouponModel.level == 2 && totalPrice >= 1000) {
      totalPrice += foodItemModel.price;
      if (foodItemModel.freeFood.isNotEmpty) {
        items.add(CartCellModel(foodItemModel: _checkFreeItem(foodItemModel)));
      }
    } else {
      totalPrice += foodItemModel.price;
      appliedCouponModel = CouponModel();
      couponValue = 0.0;
      couponApplied = false;
      if (foodItemModel.freeFood.isNotEmpty) {
        items.add(CartCellModel(foodItemModel: _checkFreeItem(foodItemModel)));
      }
    }

    notifyListeners();
  }

  void removeItem(CartCellModel item) {
    if (item.foodItemModel.name == "Salad") {
      if (items.isEmpty) {
        totalPrice = 0;
        appliedCouponModel = CouponModel();
      }
      items.remove(item);
      notifyListeners();
      return;
    } else {
      items.remove(item);
      totalPrice -= item.foodItemModel.price;
      double couponDiscount = 0.0;
      if (totalPrice >= 500 && appliedCouponModel.level == 1) {
        couponDiscount = calculateDiscountedPrice(totalPrice, 10);
      } else if (totalPrice >= 1000 && appliedCouponModel.level == 2) {
        couponDiscount = calculateDiscountedPrice(totalPrice, 20);
      }
      totalPrice -= couponDiscount;

      if (items.isEmpty) {
        totalPrice = 0;
        appliedCouponModel = CouponModel();
      }
    }

    notifyListeners();
  }

  bool couponApplied = false;
  double couponValue = 0.0;

  double applyCoupon(CouponModel couponModel) {
    appliedCouponModel = couponModel;
    if (totalPrice >= 500 && couponModel.level == 1) {
      couponValue = 0.0;
      couponValue = totalPrice -= totalPrice * 0.1;
      couponApplied = true;
      notifyListeners();
      return couponValue;
    } else if (totalPrice >= 1000 && couponModel.level == 2) {
      couponValue = 0.0;
      couponValue = totalPrice -= totalPrice * 0.2;
      couponApplied = true;
      notifyListeners();
      return couponValue;
    } else {
      couponValue = 0.0;
      couponApplied = false;
      notifyListeners();
      return 0.0;
    }
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
