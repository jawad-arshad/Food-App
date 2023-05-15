class FoodItemModel {
  String name = '';
  double price = 0.0;
  String freeFood = '';

  FoodItemModel({this.name = '',  this.freeFood = '',this.price = 0.0});
}

class CartCellModel {
  FoodItemModel foodItemModel = FoodItemModel();

  CartCellModel({required this.foodItemModel});
}

class CouponModel {
  int level = 0;
  double discount = 0.0;

  CouponModel({this.level = 0, this.discount = 0.0});
}