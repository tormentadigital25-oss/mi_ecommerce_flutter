import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/appbar/appbar.dart';
import 'package:flutter_application_1/features/shop/screens/cart/widgets/cart_items.dart';
import 'package:flutter_application_1/features/shop/screens/checkout/checkout.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:get/get.dart';




class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Cart', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: const Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: TCartItems(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: ()=> Get.to(()=> const CheckoutScreen()),
          child: const Text('Checkout \$256.0'),
        ),
      ),
    );
  }
}