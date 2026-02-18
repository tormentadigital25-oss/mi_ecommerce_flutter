import 'package:flutter/material.dart';
import 'package:flutter_application_1/common/widgets/products/cart/add_remove_button.dart';
import 'package:flutter_application_1/common/widgets/products/cart/cart_item.dart';
import 'package:flutter_application_1/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';



class TCartItems extends StatelessWidget {
  const TCartItems({super.key, this.showAddRemoveButtons = true});
  final bool showAddRemoveButtons;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (_, __) =>
          const SizedBox(height: TSizes.spaceBtwSections),
      itemCount: 2,
      itemBuilder: (_, index) => Column(
        children: [
          const TCartItem(),
          if (showAddRemoveButtons)
            const SizedBox(height: TSizes.spaceBtwItems),
          if (showAddRemoveButtons)
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(width: 70),
                    TProductQuantityWithAddRemoveButton(),
                  ],
                ),
                TProductPriceText(price: '256'),
              ],
            ),
        ],
      ),
    );
  }
}