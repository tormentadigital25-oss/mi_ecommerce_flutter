import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/common/widgets/brands/brand_show_case.dart';
import 'package:flutter_application_1/common/widgets/layouts/grid_layout.dart';
import 'package:flutter_application_1/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:flutter_application_1/common/widgets/texts/section_heading.dart';
import 'package:flutter_application_1/utils/constants/image_strings.dart';
import 'package:flutter_application_1/utils/constants/sizes.dart';


class TCategoryTab extends StatelessWidget {
  const TCategoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              const TBrandShowcase(
                images: [
                  TImages.productImage66,
                  TImages.productImage1,
                  TImages.productImage11,
                ],
              ),
              const TBrandShowcase(
                images: [
                  TImages.productImage66,
                  TImages.productImage1,
                  TImages.productImage11,
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              TSectionHeading(title: 'You might like', onPressed: () {}),
              const SizedBox(height: TSizes.spaceBtwItems),
              TGridLayout(
                itemCount: 4,
                itemBuilder: (_, index) => const TProductCardVertical(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}