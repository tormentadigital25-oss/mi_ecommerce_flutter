import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_application_1/common/widgets/layouts/grid_layout.dart';
import 'package:flutter_application_1/common/widgets/products/product_cards/product_card_vertical.dart';


class TSortableProducts extends StatelessWidget {
  const TSortableProducts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButtonFormField(
          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
          items:
              [
                    'Name',
                    'Higher Price',
                    'Lower Price',
                    'Sale',
                    'Newest',
                    'Popularity',
                  ]
                  .map(
                    (option) => DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    ),
                  )
                  .toList(),
          onChanged: (value) {},
        ),
        const SizedBox(height: TSizes.spaceBtwSections),
    
        TGridLayout(
          itemCount: 8,mainAxisExtent: 310,
          itemBuilder: (_, index) => const TProductCardVertical(),
        ),
      ],
    );
  }
}