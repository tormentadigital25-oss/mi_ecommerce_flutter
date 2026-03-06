

import 'package:flutter_application_1/features/cart/models/cart_item_model.dart';

class CartModel {
  String cartId;
  List<CartItemModel> items;

  CartModel({
    required this.cartId,
    required this.items,
  });

  static CartModel empty() => CartModel(cartId: '', items: []);
}